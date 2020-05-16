require "vim_mapping_manager/version"
require 'tempfile'

module CommandHelpers
  def current_file_path
    "<C-R>=expand('%')<CR>"
  end
end

module VimMappingManager
  extend CommandHelpers
  class Error < StandardError; end

  @global_key_strokes = {}

  def self.call(&block)
    instance_exec(&block)
  end

  def self.render
    @global_key_strokes.values.each(&:render)
    OutputFile.output
  end

  private

  def self.normal(key, command, desc:, &block)
    find_key_stroke(key).set_normal(command, desc: desc)
    find_key_stroke(key).instance_exec(&block) if block
  end

  def self.prefix(key, name:, desc:, &block)
    find_key_stroke(key).set_prefix(name: name, desc: desc)
    find_key_stroke(key).instance_exec(&block) if block
  end

  def self.find_key_stroke(key)
    @global_key_strokes[key] ||= KeyStroke.new(key)
  end

  class KeyStroke
    attr_reader :key, :prefix, :normal

    def initialize(key)
      @key = key
    end

    # Set prefix informations for this key stroke
    def set_prefix(name:, desc:)
      raise("#{key} is already defined as a prefix") if prefix

      @prefix = Prefix.new(name, self, desc)
    end

    # Defines a normal command
    def set_normal(command, desc: nil)
      raise("#{key} is already defined as a normal command") if normal

      @normal = NormalCommand.new(command, self, desc: desc)
    end

    def render
      prefix&.render
      normal&.render
    end
  end

  class NormalCommand
    attr_reader :command, :desc, :prefix, :key

    def initialize(command, keystroke, desc: nil)
      @command = command
      @desc = desc
      @prefix = keystroke.prefix
      @key = keystroke.key
    end

    def render
      OutputFile.write "\" #{desc}"
      if prefix
        OutputFile.write " nnoremap <silent> [#{prefix.name}]#{key} #{command}"
      else
        OutputFile.write " nnoremap <silent> #{key} #{command}\n"
      end
    end
  end

  class Prefix
    attr_reader :name, :desc, :key

    def initialize(name,keystroke, desc: nil)
      @name = name
      @desc = desc
      @key = keystroke.key
    end

    def render
      OutputFile.write '" -----------------------------------------------------------------------------'
      OutputFile.write "\" Prefix: #{name}, key: #{key}"
      OutputFile.write "\" #{desc}"
      OutputFile.write '" -----------------------------------------------------------------------------'
      OutputFile.write "  nnoremap  [#{name}] <Nop>"
      OutputFile.write "  nmap      #{key} [Files]"
    end
  end
end

class OutputFile
  @tempfile = ::Tempfile.new()

  def self.write(content)
    @tempfile << content + "\n"
  end

  def self.output
    @tempfile.rewind
    @tempfile.read
  end
end
