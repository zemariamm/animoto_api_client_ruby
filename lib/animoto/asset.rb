module Animoto
  class Asset
    
    attr_accessor :source_url
    
    def initialize source_url, options = {}
      @source_url = source_url
    end
    
    # Returns a representation of this asset as a Hash. Used mainly for generating
    # manifests.
    #
    # @return [Hash] this asset as a Hash
    def to_hash
      { 'source_url' => @source_url }
    end
    
    # Returns a representation of this asset as JSON.
    #
    # @return [String] this asset as JSON
    def to_json
      self.to_hash.to_json
    end
  end
end