class Prefix
  include CommandHelpers
  attr_reader :name, :desc, :key, :key_strokes

  def initialize(name, keystroke, desc: nil)
    @name = name
    @desc = desc
    @key = keystroke.key
    @key_strokes = {}
  end

  def normal(key, command, desc:)
    raise("Mapping for #{key} already exists") if key_strokes[key] 

    keystroke = KeyStroke.new(key, self)
    keystroke.set_normal(command, desc: desc)

    key_strokes[key] = keystroke
  end

  def which_key_map
    "g:which_key_map_#{name_parameterize}"
  end

  def name_parameterize
    name.downcase.strip.gsub(/ +/, '_')
  end

  def render
    lines = [
      "\n\n\" ----------------------------------------------------------------",
      "\" Prefix: #{name}, key: #{key}",
      "\" #{desc}",
      '" ----------------------------------------------------------------',
      "let #{which_key_map} = { 'name' : '+#{name_parameterize}' }",
      "if exists(':WhichKey')",
      "  call which_key#register('#{key}', '#{which_key_map}')",
      'endif',
      '',
      "nnoremap #{key} :<c-u>WhichKey '#{key}'<CR>",
      "vnoremap #{key} :<c-u>WhichKeyViual '#{key}'<CR>"
    ]

    lines.each { |line| OutputFile.write(line) }
    key_strokes.values.each(&:render)

    lines.join("\n")
  end
end
