module Mappers
  class Base
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
        OutputFile.write "#{map_keyword} <silent> #{prefix.key}#{key} #{command}"
        OutputFile.write "let #{@prefix.which_key_map}.#{key} = '#{desc}'"
      else
        OutputFile.write "#{map_keyword} <silent> #{key} #{command}"
      end
    end
  end
end
