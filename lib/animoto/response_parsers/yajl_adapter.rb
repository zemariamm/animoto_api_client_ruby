require 'yajl'

module Animoto
  module ResponseParsers
    class YajlAdapter < Animoto::ResponseParsers::Base
      
      @format = 'json'
      
      # @return [Hash<String,Object>]
      def parse string
        ::Yajl::Parser.parse string
      end
      
      # @return [String]
      def unparse object
        ::Yajl::Encoder.encode object
      end      
    end
    
    adapter_map.merge! :yajl => YajlAdapter
  end
end