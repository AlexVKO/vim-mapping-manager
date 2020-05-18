require_relative './base_mapper.rb'

module Mappers
  class Normal < Base
    def map_keyword
      'nnoremap'
    end

    def render_mapping
      if command.start_with?(':') && execute
        super + "<CR>"
      else
        super
      end
    end
  end
end
