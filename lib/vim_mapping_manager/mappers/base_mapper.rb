module Mappers
  class Base
    attr_reader :command, :desc, :prefix, :key, :indentation

    def initialize(command, keystroke, desc: nil)
      @command = command
      @desc = desc
      @prefix = keystroke.parent_prefix
      @key = keystroke.key
      @indentation = ' ' * keystroke.indentation_level
    end

    def render
      OutputFile.write "\n#{indentation}\"#{desc}"

      if prefix
        OutputFile.write "#{indentation}#{map_keyword} <silent> #{prefix.key}#{key} #{command}"
        OutputFile.write "#{indentation}let #{@prefix.which_key_map}.#{key} = '#{desc}'"
      else
        OutputFile.write "#{indentation}#{map_keyword} <silent> #{key} #{command}"
      end
    end
  end
end
