require_relative './base_mapper.rb'

module Mappers
  class Normal < Base
    def map_keyword
      'nnoremap'
    end

    def render_mapping
      super + "<CR>"
    end
  end
end
