require_relative './base_mapper.rb'

module Mappers
  class Insert < Base
    def map_keyword
      if recursively
        'imap'
      else
        'inoremap'
      end
    end
  end
end
