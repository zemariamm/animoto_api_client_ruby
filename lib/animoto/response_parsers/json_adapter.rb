require 'json'

module Animoto
  module ResponseParsers
    class JSONAdapter < Animoto::ResponseParsers::Base
      
      @format = 'json'
      
      # @return [Hash{String=>Object}]
      def parse string
        ::JSON.parse string
      end
      
      # @return [String]
      def unparse object
        ::JSON.unparse object
      end
    end    
  end
end