class Prefix
  include CommandHelpers
  attr_reader :name,
    :desc,
    :key_strokes,
    :keystroke,
    :is_sub_prefix 

  def initialize(name, keystroke, desc: nil)
    @name = name.to_s
    @keystroke = keystroke
    @desc = desc
    @key_strokes = {}
      "g:which_key_map_#{name_parameterize}"
  end

  def parent_key
    keystroke.parent&.whole_key || ''
  end

  def filetype
    keystroke.filetype
  end

  def key
    keystroke.key
  end
  
  # # ex: g:which_key_map_prefixname
  def which_key_map
    parent = keystroke.parent
    from_parent = parent&.prefix&.which_key_map || parent&.leader&.which_key_map

    if from_parent
      @is_sub_prefix = true
      if key != ''
        from_parent + "['#{key}']"
      else
        from_parent 
      end
    else
      "g:which_key_map_#{name_parameterize}"
    end
  end

  def find_or_create_keystroke(key, filetype:)
    key_strokes[key+filetype.to_s] ||= 
      KeyStroke.new(key,
                    parent: keystroke,
                    indentation_level: keystroke.indentation_level, 
                    filetype: filetype
                   )
  end

  # Create a nested prefix
  def prefix(key = '', name:, desc:, filetype: nil, &block)
    key_stroke = find_or_create_keystroke(key, filetype: filetype)
    raise("Mapping for #{key} already exists") if key_stroke.prefix

    key_stroke.indentation_level = keystroke.indentation_level + 2
    key_stroke.set_prefix(name: @name + " > " + name, desc: desc)
    key_stroke.prefix.instance_exec(&block) if block
  end

  # Create a normal command
  def normal(key, command, desc:, filetype: nil, execute: true)
    key_stroke = find_or_create_keystroke(key, filetype: filetype || keystroke.filetype)
    raise("Mapping for #{key} already exists") if key_stroke.normal

    key_stroke.set_normal(command, desc: desc, execute: execute)
  end

  # Create a visual command
  def visual(key, command, desc:, filetype: nil)
    key_stroke = find_or_create_keystroke(key, filetype: filetype || keystroke.filetype)

    raise("Mapping for #{key} already exists") if key_stroke.visual

    key_stroke.set_visual(command, desc: desc)
  end

  def name_parameterize
    name.downcase.strip.gsub(/ +/, '_').gsub(/[^_A-Za-z]/, '')
  end

  def render_which_prefix
    return [] if key == ''

    if which_key_map && is_sub_prefix
      [
        "let #{which_key_map} = { 'name' : '+#{name}' }"
      ]
    else
      [
        "let #{which_key_map} = { 'name' : '+#{name}' }",
        "call which_key#register('#{key}', '#{which_key_map}')",
        "nnoremap #{key} :<c-u>WhichKey '#{key}'<CR>",
        "vnoremap #{key} :<c-u>WhichKeyVisual '#{key}'<CR>",
      ]
    end
  end

  def render_filetype
    if filetype
      ["\" Filetype: #{filetype}"]
    else
      []
    end
  end

  def render_header
    [
      "",
      "",
      "\" ----------------------------------------------------------------",
      "\" #{key == '' ? 'Namespace' : 'Prefix'} #{name}",
      "\" Key #{parent_key}#{keystroke.key}",
      *render_filetype,
      "\" #{desc}",
      '" ----------------------------------------------------------------',
      *render_which_prefix,
    ].map { |line| (' ' * keystroke.indentation_level) + line }
      .each { |line| OutputFile.write(line) }
  end

  def render
    render_header
    key_strokes.values.each(&:render)
  end
end
