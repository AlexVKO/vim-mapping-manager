class Prefix
  include CommandHelpers
  attr_reader :name, :desc, :key, :key_strokes, :indentation_level, :is_sub_prefix, :which_key_map, :parent_key

  def initialize(name, keystroke, desc: nil, which_key_map: nil)
    @name = name
    @desc = desc
    @key = keystroke.key
    @key_strokes = {}
    @indentation_level = keystroke.indentation_level
    @parent_key = keystroke.parent_prefix&.key || ''
    @is_sub_prefix = !!which_key_map
    @which_key_map = which_key_map || "g:which_key_map_#{name_parameterize}"
  end

  def which_key_map=(value)
    @is_sub_prefix = true
    @which_key_map = value + "." + key.gsub(@parent_key, '')
  end

  def find_or_create_keystroke(key)
    key_strokes[key] ||= KeyStroke.new(key, self, indentation_level: indentation_level)
  end

  # Create a nested prefix
  def prefix(key, name:, desc:, &block)
    key_stroke = find_or_create_keystroke(key)
    raise("Mapping for #{key} already exists") if key_strokes[key].prefix

    key_stroke.indentation_level = indentation_level + 2
    key_stroke.set_prefix(name: @name + " > " + name, desc: desc)
    key_stroke.prefix.which_key_map = which_key_map
    key_stroke.prefix.instance_exec(&block) if block
  end

  # Create a normal command
  def normal(key, command, desc:)
    key_stroke = find_or_create_keystroke(key)

    raise("Mapping for #{key} already exists") if key_strokes[key].normal

    key_strokes[key].set_normal(command, desc: desc)
  end

  # Create a visual command
  def visual(key, command, desc:)
    key_stroke = find_or_create_keystroke(key)

    raise("Mapping for #{key} already exists") if key_strokes[key].visual

    key_strokes[key].set_visual(command, desc: desc)
  end

  def name_parameterize
    name.downcase.strip.gsub(/ +/, '_').gsub(/[^_A-Za-z]/, '')
  end

  def render_which_prefix
    if is_sub_prefix
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

  def render_header
    [
      "",
      "",
      "\" ----------------------------------------------------------------",
      "\" Prefix: #{name}",
      "\" Key #{parent_key}#{key}",
      "\" #{desc}",
      '" ----------------------------------------------------------------',
      *render_which_prefix,
    ].map { |line| (' ' * indentation_level) + line }
    .each { |line| OutputFile.write(line) }
  end

  def render
    render_header

    key_strokes.values.each(&:render)
  end
end
