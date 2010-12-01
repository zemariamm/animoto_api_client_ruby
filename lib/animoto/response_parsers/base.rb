module Animoto
  module ResponseParsers    
    extend Support::DynamicClassLoader
    
    dynamic_class_path File.expand_path(File.dirname(__FILE__))
    
    adapter 'JSON'
    adapter 'Yajl'
    
    # @abstract Override {#parse}, {#unparse}, and {#format} (or set @format on the class) to subclass.
    class Base
    
      # Returns the format of this parser class.
      # 
      # @return [String] the format
      def self.format
        @format
      end
    
      # Returns the format of this parser.
      #
      # @return [String] the format
      def format
        self.class.format
      end
    
      # Parses a response body into a usable Hash.
      #
      # @abstract
      # @param [String] body the HTTP response body
      # @return [Hash{String=>Object}] the parsed response
      # @raise [AbstractMethodError] if called on the abstract class
      def parse body
        raise AbstractMethodError
      end
    
      # Serializes a Hash into the format for this parser.
      #
      # @abstract
      # @param [Hash{Object=>Object}] hash the hash to serialize
      # @return [String] the serialized data
      # @raise [AbstractMethodError] if called on the abstract class
      def unparse hash
        raise AbstractMethodError
      end

    end
  end
end