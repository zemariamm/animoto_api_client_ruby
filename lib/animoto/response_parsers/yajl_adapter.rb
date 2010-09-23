require 'yajl'

module Animoto
  module ResponseParsers
    class YajlAdapter < Animoto::ResponseParsers::Base
      
      @format = 'json'
      
      def parse string
        ::Yajl::Parser.parse string
      end
      
      def unparse object
        ::Yajl::Encoder.encode object
      end      
    end
    
    adapter_map.merge! :yajl => YajlAdapter
  end
end