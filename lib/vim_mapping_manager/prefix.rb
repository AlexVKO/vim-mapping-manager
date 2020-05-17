class Prefix
  include CommandHelpers
  attr_reader :name, :desc, :key, :key_strokes, :indentation_level

  def initialize(name, keystroke, desc: nil)
    @name = name
    @desc = desc
    @key = keystroke.key
    @key_strokes = {}
    @indentation_level = keystroke.indentation_level
  end

  # Create a nested prefix
  def prefix(key, name:, desc:, &block)
    key = @key + key

    key_strokes[key] ||= KeyStroke.new(key, self)

    raise("Mapping for #{key} already exists") if key_strokes[key].prefix

    key_strokes[key].indentation_level = indentation_level + 2
    key_strokes[key].set_prefix(name: @name + " > " + name, desc: desc)
    key_strokes[key].prefix.instance_exec(&block) if block
  end

  # Create a normal command
  def normal(key, command, desc:)
    key_strokes[key] ||= KeyStroke.new(key, self, indentation_level: indentation_level)

    raise("Mapping for #{key} already exists") if key_strokes[key].normal

    key_strokes[key].set_normal(command, desc: desc)
  end

  # Create a visual command
  def visual(key, command, desc:)
    key_strokes[key] ||= KeyStroke.new(key, self)

    raise("Mapping for #{key} already exists") if key_strokes[key].visual

    key_strokes[key].set_visual(command, desc: desc)
  end

  def which_key_map
    "g:which_key_map_#{name_parameterize}"
  end

  def name_parameterize
    name.downcase.strip.gsub(/ +/, '_').gsub(/[^_A-Za-z]/, '')
  end

  def render_header
    [
      "",
      "",
      "\" ----------------------------------------------------------------",
      "\" Prefix: #{name}",
      "\" Key #{key}",
      "\" #{desc}",
      '" ----------------------------------------------------------------',
      "let #{which_key_map} = { 'name' : '+#{name_parameterize}' }",
      "if exists(':WhichKey')",
      "  call which_key#register('#{key}', '#{which_key_map}')",
      'endif',
      '',
      "nnoremap #{key} :<c-u>WhichKey '#{key}'<CR>",
      "vnoremap #{key} :<c-u>WhichKeyViual '#{key}'<CR>"
    ].map { |line| (' ' * indentation_level) + line }
    .each { |line| OutputFile.write(line) }
  end

  def render
    render_header

    key_strokes.values.each(&:render)
  end
end
