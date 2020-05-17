require 'forwardable'

module Mappers
  class Base
    extend Forwardable

    attr_reader :command, :desc, :keystroke

    def initialize(command, keystroke, desc: nil)
      @command = command
      @keystroke = keystroke
      @desc = desc
    end

    def_delegators :@keystroke, :key, :parent

    def render
      OutputFile.write "\n#{indentation}\" #{desc}"

      render_mapping
      render_which_key if self.to_s.include?('Normal')
    end

    private

    def render_mapping
      OutputFile.write "#{indentation}#{autocmd}#{map_keyword} <silent> #{parent&.whole_key}#{key} #{command}"
    end

    def render_which_key
      OutputFile.write "#{indentation}#{autocmd}call extend(#{parent&.which_key_map}, {'#{key}':'#{desc_presence || 'which_key_ignore'}'})"
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
