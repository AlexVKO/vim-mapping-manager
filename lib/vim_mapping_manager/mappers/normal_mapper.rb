module Mappers
  class Normal
    attr_reader :command, :desc, :prefix, :key

    def initialize(command, keystroke, desc: nil)
      @command = command
      @desc = desc
      @prefix = keystroke.parent_prefix
      @key = keystroke.key
    end

    def render
      OutputFile.write "\n\" #{desc}"
      if prefix
        OutputFile.write " nnoremap <silent> [#{prefix.name}]#{key} #{command}"
      else
        OutputFile.write " nnoremap <silent> #{key} #{command}\n"
      end
    end
  end
end
