require 'yajl'

module Animoto
  class ResponseParser
    class YajlAdapter < Animoto::ResponseParser
      
      @format = 'json'
      
      def parse body
        ::Yajl::Parser.parse body
      end
      
      def unparse hash
        ::Yajl::Encoder.encode hash
      end
      
    end
    
    adapter_map.merge! :yajl => YajlAdapter
  end
end