module Animoto
  class ResponseParser
    extend DynamicClassLoader
    
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
    # @param [String] body the HTTP response body
    # @return [Hash] the parsed response
    # @raise [NotImplementedError] if called on the abstract class
    def parse body
      raise NotImplementedError
    end
    
    # Serializes a Hash into the format for this parser.
    #
    # @param [Hash] hash the hash to serialize
    # @return [String] the serialized data
    # @raise [NotImplementedError] if called on the abstract class
    def unparse hash
      raise NotImplementedError
    end

  end
end