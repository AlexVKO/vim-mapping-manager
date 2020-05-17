require_relative './prefix.rb'

class Leader < Prefix
  include CommandHelpers
  attr_reader :key, :key_strokes

  def initialize(keystroke)
    @key = keystroke.key
    @key_strokes = {}
    @indentation_level = keystroke.indentation_level
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
      "let mapleader='#{key}'",
      "",
      "if !exists('#{which_key_map}')",
      "  let #{which_key_map} = {}",
      "endif",
      "call which_key#register('#{key}', '#{which_key_map}')",
      "nnoremap #{key} :<c-u>WhichKey '#{key}'<CR>",
      "vnoremap #{key} :<c-u>WhichKeyVisual '#{key}'<CR>"
    ].map { |line| (' ' * indentation_level) + line }
      .each { |line| OutputFile.write(line) }
  end
end
