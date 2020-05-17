require_relative './prefix.rb'

class Leader < Prefix
  include CommandHelpers
  attr_reader :key, :key_strokes

  def initialize(keystroke)
    @key = keystroke.key
    @key_strokes = {}
  end

  def which_key_map
    "g:which_key_map"
  end

  def name_parameterize
    'leader'
  end

  def render
    lines = [
      "\n\" ----------------------------------------------------------------",
      "\" Leader, key: #{key}",
      '" ----------------------------------------------------------------',
      "let mapleader='#{key}'",
      "",
      "if !exists('#{which_key_map}')",
      "  let #{which_key_map} = {}",
      "endif",
      "if exists(':WhichKey')",
      "  call which_key#register('#{key}', '#{which_key_map}')",
      'endif'
    ]

    lines.each { |line| OutputFile.write(line) }

    key_strokes.values.each(&:render)

    lines.join("\n")
  end
end
