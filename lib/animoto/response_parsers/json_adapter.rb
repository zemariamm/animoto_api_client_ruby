require 'json'

module Animoto
  module ResponseParsers
    class JSONAdapter < Animoto::ResponseParsers::Base
      
      @format = 'json'
      
      def parse string
        ::JSON.parse string
      end
      
      def unparse object
        ::JSON.unparse object
      end
    end
    
    adapter_map.merge! :json => JSONAdapter
  end
end