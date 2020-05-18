require_relative './base_mapper.rb'

module Mappers
  class Visual < Base
    def map_keyword
      if recursively
        'xmap'
      else
        'xnoremap'
      end
    end
  end
end
