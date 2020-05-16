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

  def render
    lines = [
      '" ----------------------------------------------------------------',
      "\" Prefix: #{name}, key: #{key}",
      "\" #{desc}",
      '" ----------------------------------------------------------------',
      "  nnoremap  [#{name}] <Nop>",
      "  nmap      #{key} [Files]",
    ]

    lines.each { |line| OutputFile.write(line) }
    key_strokes.values.each(&:render)

    lines.join("\n")
  end
end
