require 'yajl'

module Animoto
  class ResponseParser
    class Yajl < Animoto::ResponseParser
      
      @format = 'json'
      
      def parse body
        ::Yajl::Parser.parse body
      end
      
      def unparse hash
        ::Yajl::Encoder.encode hash
      end
      
    end
  end
end