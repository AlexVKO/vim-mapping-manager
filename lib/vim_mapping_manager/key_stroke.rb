require_relative '../vim_mapping_manager/mappers/normal_mapper.rb'
require_relative '../vim_mapping_manager/mappers/visual_mapper.rb'
require_relative '../vim_mapping_manager/prefix.rb'
require_relative '../vim_mapping_manager/leader.rb'

class KeyStroke
  include CommandHelpers
  attr_reader :parent, :filetype,
    :leader, :prefix, :normal, :visual

  attr_accessor :indentation_level

  def initialize(key, parent: nil, indentation_level: 0, filetype: nil)
    @key = key
    @parent = parent
    @filetype = filetype
    @indentation_level = indentation_level
  end

  def key
    leader&.key || @key
  end

  def whole_key
    parent&.whole_key.to_s + key
  end

  def which_key_map 
    leader&.which_key_map || prefix&.which_key_map  
  end

  # Set leader informations for this key stroke
  def set_leader
    raise("#{key} is already defined as a prefix") if prefix
    raise("#{key} is already defined as a leader") if leader

    @leader = Leader.new(self)
  end

  # Set prefix informations for this key stroke
  def set_prefix(name:, desc:)
    raise("#{key} is already defined as a prefix") if prefix
    raise("#{key} is already defined as a leader") if leader

    @prefix = Prefix.new(name, self, desc: desc)
  end

  # Defines a visual command
  def set_visual(command, desc: nil, recursively:)
    raise("#{key} is already defined as a visual command") if @visual

    @visual = Mappers::Visual.new(command, self, desc: desc, recursively: recursively)
  end

  # Defines a normal command
  def set_normal(command, desc: nil, execute:, recursively:)
    raise("#{key} is already defined as a normal command") if @normal

    @normal = Mappers::Normal.new(command, self, desc: desc, execute: execute, recursively: recursively)
  end

  def render
    leader&.render
    prefix&.render
    normal&.render
    visual&.render
  end
end
