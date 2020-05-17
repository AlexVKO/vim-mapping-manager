module Mappers
  class Command
    attr_reader :name, :command, :desc, :filetype

    def initialize(name, command, desc:, filetype: nil)
      @name = name
      @command = command
      @filetype = filetype
      @desc = desc
    end

    def autocmd
      "autocmd FileType #{filetype} " if filetype
    end

    def render
      OutputFile.write "\" #{desc}"
      OutputFile.write "#{autocmd}command! #{name} #{command}"
    end
  end
end
