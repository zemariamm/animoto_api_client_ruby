module Animoto
  class Asset
    
    attr_accessor :source
    
    def initialize source, options = {}
      @source = source
    end
    
    # Returns a representation of this asset as a Hash. Used mainly for generating
    # manifests.
    #
    # @return [Hash] this asset as a Hash
    def to_hash
      { 'source' => @source }
    end
    
  end
end