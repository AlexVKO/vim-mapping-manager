require "vim_mapping_manager/version"

require 'vim_mapping_manager/command_helpers.rb'
require 'vim_mapping_manager/output_file.rb'
require 'vim_mapping_manager/key_stroke.rb'
require 'vim_mapping_manager/prefix.rb'
require 'vim_mapping_manager/normal_command.rb'

module VimMappingManager
  extend CommandHelpers
  class Error < StandardError; end

  @global_key_strokes = {}

  def self.reset!
    @global_key_strokes = {}
  end

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
    find_key_stroke(key).prefix.instance_exec(&block) if block
  end

  def self.find_key_stroke(key)
    @global_key_strokes[key] ||= KeyStroke.new(key, nil)
  end
end
