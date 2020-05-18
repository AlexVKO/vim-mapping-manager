require_relative "./vim_mapping_manager/version"

require_relative './vim_mapping_manager/command_helpers.rb'
require_relative './vim_mapping_manager/output_file.rb'
require_relative './vim_mapping_manager/key_stroke.rb'
require_relative './vim_mapping_manager/mappers/command_mapper.rb'
require_relative './vim_mapping_manager/execute_ruby_mapping.rb'

module VimMappingManager
  extend CommandHelpers
  class Error < StandardError; end

  @global_key_strokes = {}
  @global_commands = {}

  def self.file_config_path
    File.expand_path('~/.config/nvim/managed_mappings.rb')
  end

  def self.save
    reset!
    file = File.read(file_config_path)
    call do
      instance_eval file
    end
    render
    OutputFile.save
  end

  def self.reset!
    @global_key_strokes = {}
    @global_commands = {}
    @leader_key = nil
    ExecuteRubyMapping.reset!
  end

  def self.call(&block)
    instance_exec(&block)
  end

  def self.render
    OutputFile.reset!

    @global_key_strokes.values.each(&:render)

    render_command_mappins

    OutputFile.output
  end

  private

  def self.visual(key, command = nil, desc:, filetype: nil, recursively: false, &block)
    find_key_stroke(key, filetype: filetype).set_visual(command || block, desc: desc, recursively: recursively)
  end

  def self.insert(key, command = nil, desc:, filetype: nil, execute: true, recursively: false, &block)
    find_key_stroke(key, filetype: filetype).set_insert(command || block, desc: desc, execute: execute, recursively: recursively)
  end

  def self.normal(key, command = nil, desc:, filetype: nil, execute: true, recursively: false, &block)
    find_key_stroke(key, filetype: filetype).set_normal(command || block, desc: desc, execute: execute, recursively: recursively)
  end

  def self.leader(key, &block)
    find_key_stroke(key).set_leader
    find_key_stroke(key).leader.instance_exec(&block) if block
  end

  def self.prefix(key = '', name:, desc:, filetype: nil, &block)
    key_stroke = find_key_stroke(key, filetype: filetype)
    key_stroke.set_prefix(name: name, desc: desc)
    key_stroke.prefix.instance_exec(&block) if block
  end

  def self.command(name, command, desc:, filetype: nil)
    raise("A command with #{name} was already defined") if @global_commands[name]
    @global_commands[name] = Mappers::Command.new(name, command, desc: desc, filetype: filetype)
  end

  def self.render_command_mappins
    return if @global_commands.values.none?
    OutputFile.write "\n\n\" ----------------------------------------------------------------"
    OutputFile.write "\" Commands"
    OutputFile.write '" ----------------------------------------------------------------'
    @global_commands.values.each(&:render)
  end

  def self.find_key_stroke(key, filetype: nil)
    @global_key_strokes[key+filetype.to_s] ||= KeyStroke.new(key, filetype: filetype)
  end
end
