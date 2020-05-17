module Mappers
  class Visual
    attr_reader :command, :desc, :prefix, :key

    def initialize(command, keystroke, desc: nil)
      @command = command
      @desc = desc
      @prefix = keystroke.parent_prefix
      @key = keystroke.key
    end

    def render
      OutputFile.write "\" #{desc}"
      if prefix
        OutputFile.write " xnoremap <silent> [#{prefix.name}]#{key} #{command}"
      else
        OutputFile.write " xnoremap <silent> #{key} #{command}"
      end
    end
  end
end
