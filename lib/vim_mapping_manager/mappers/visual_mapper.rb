require_relative './base_mapper.rb'

module Mappers
  class Visual < Base
    def map_keyword 
      'xnoremap'
    end
  end
end
