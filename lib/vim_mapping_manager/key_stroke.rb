require_relative '../vim_mapping_manager/mappers/normal_mapper.rb'
require_relative '../vim_mapping_manager/prefix.rb'

class KeyStroke
  include CommandHelpers
  attr_reader :key, :prefix, :normal, :parent_prefix

  def initialize(key, parent_prefix = nil)
    @key = key
    @parent_prefix = parent_prefix
  end

  # Set prefix informations for this key stroke
  def set_prefix(name:, desc:)
    raise("#{key} is already defined as a prefix") if prefix

    @prefix = Prefix.new(name, self, desc: desc)
  end

  # Defines a normal command
  def set_normal(command, desc: nil)
    raise("#{key} is already defined as a normal command") if @normal

    @normal = Mappers::Normal.new(command, self, desc: desc)
  end

  def render
    prefix&.render
    normal&.render
  end
end
