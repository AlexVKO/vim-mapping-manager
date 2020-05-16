require "vim_mapping_manager/version"
require 'tempfile'

module VimMappingManager
  class Error < StandardError; end

  @global_key_strokes = {}

  def self.prefix(key, name:, desc:, &block)
    find_key_stroke(key).set_prefix(name: name, desc: desc)
    find_key_stroke(key).instance_exec(&block)
  end

  def self.render
    @global_key_strokes.values.each(&:render)
    OutputFile.output
  end

  private

  def self.find_key_stroke(key)
    @global_key_strokes[key] ||= KeyStroke.new(key)
  end

  class KeyStroke
    attr_reader :key, :prefix

    def initialize(key)
      @key = key
    end

    # Set prefix informations for this key stroke
    def set_prefix(name:, desc:)
      raise("#{key} is already defined as a prefix") if prefix

      @prefix = Prefix.new(name, desc)
    end

    # Defines a normal command
    def normal(key, command, desc: nil)
    end

    def render
      prefix.render(key)
    end
  end

  class Prefix
    attr_reader :name, :desc

    def initialize(name, desc)
      @name = name
      @desc = desc
    end

    def render(key)
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
