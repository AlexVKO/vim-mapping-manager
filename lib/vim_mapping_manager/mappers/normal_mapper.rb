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

    def render_mapping
      if command.start_with?(':') && execute
        super + "<CR>"
      else
        super
      end
    end
  end
end
