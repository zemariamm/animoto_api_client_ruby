require 'json'

module Animoto
  class ResponseParser
    class JSONAdapter < Animoto::ResponseParser
      
      @format = 'json'
      
      def parse body
        ::JSON.parse body
      end
      
      def unparse hash
        ::JSON.unparse hash
      end
      
    end
    
    adapter_map.merge! :json => JSONAdapter
  end
end