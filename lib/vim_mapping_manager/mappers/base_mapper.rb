require 'forwardable'

module Mappers
  class Base
    extend Forwardable

    attr_reader :command, :desc, :keystroke, :execute, :recursively

    def initialize(command, keystroke, desc: nil, execute: true, recursively:)
      @command = command
      @recursively = recursively
      @keystroke = keystroke
      @desc = desc
      @execute = execute
    end

    def_delegators :@keystroke, :key, :parent

    def render
      OutputFile.write "\n#{indentation}\" #{desc}"

      OutputFile.write render_mapping
      OutputFile.write render_which_key if self.to_s.include?('Normal')
    end

    private

    def render_mapping
      "#{indentation}#{autocmd}#{map_keyword} #{parent&.whole_key}#{key} #{command}"
    end

    def render_which_key
      if parent&.which_key_map
        "#{indentation}#{autocmd}call extend(#{parent.which_key_map}, {'#{key}':'#{desc_presence || 'which_key_ignore'}'})"
      end
    end

    def autocmd
      if (filetype = keystroke.filetype)
        "autocmd FileType #{filetype} "
      end
    end

    def indentation
      ' ' * keystroke.indentation_level
    end

    def desc_presence
      return if desc.nil? || desc == ''
      desc.capitalize
    end

  end
end
