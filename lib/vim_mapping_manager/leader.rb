require_relative './prefix.rb'

class Leader < Prefix
  include CommandHelpers
  attr_reader :key_strokes, :actual_key

  def initialize(keystroke)
    @keystroke = keystroke
    @actual_key = keystroke.key
    @name = 'Leader'
    @key_strokes = {}
  end

  def key
    '<leader>'
  end

  def which_key_map
    "g:which_key_map"
  end

  def name_parameterize
    'leader'
  end

  def render_header
    [
      "\n\" ----------------------------------------------------------------",
      "\" Leader",
      '" ----------------------------------------------------------------',
      "let mapleader='#{actual_key}'",
      "",
      "if !exists('#{which_key_map}')",
      "  let #{which_key_map} = {}",
      "endif",
      "call which_key#register('#{actual_key}', '#{which_key_map}')",
      "nnoremap #{key} :<c-u>WhichKey '#{key}'<CR>",
      "vnoremap #{key} :<c-u>WhichKeyVisual '#{key}'<CR>"
    ].map { |line| (' ' * keystroke.indentation_level) + line }
      .each { |line| OutputFile.write(line) }
  end
end
