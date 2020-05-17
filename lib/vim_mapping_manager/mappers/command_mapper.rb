module Mappers
  class Command
    attr_reader :name, :command, :desc

    def initialize(name, command, desc:)
      @name = name
      @command = command
      @desc = desc
    end

    def render
      OutputFile.write "\n\" #{desc}"
      OutputFile.write "command! #{name} #{command}"
    end
  end
end
