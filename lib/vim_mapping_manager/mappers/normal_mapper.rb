require_relative './base_mapper.rb'

module Mappers
  class Normal < Base
    def map_keyword
      if recursively
        'nmap'
      else
        'nnoremap'
      end
    end
  end
end
