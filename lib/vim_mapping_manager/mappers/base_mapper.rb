module Mappers
  class Base
    attr_reader :command, :desc, :prefix, :key, :keystroke

    def initialize(command, keystroke, desc: nil)
      @command = command
      @desc = desc
      @prefix = keystroke.parent_prefix
      @key = keystroke.key
      @keystroke = keystroke
    end

    def indentation
      ' ' * keystroke.indentation_level
    end

    def desc_presence
      return if desc.nil? || desc == ''
      desc.capitalize
    end

    def render
      OutputFile.write "\n#{indentation}\"#{desc}"

      if prefix
        OutputFile.write "#{indentation}#{map_keyword} <silent> #{prefix.parent_key}#{prefix.key}#{key} #{command}"
        if self.to_s.include?('Normal')
          OutputFile.write "#{indentation}call extend(#{@prefix.which_key_map}, {'#{key}':'#{desc_presence || 'which_key_ignore'}'})"
        end
      else
        OutputFile.write "#{indentation}#{map_keyword} <silent> #{key} #{command}"
      end
    end
  end
end
