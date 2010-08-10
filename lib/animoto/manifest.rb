module Animoto
  class Manifest
    include ContentType
    
    # Returns a representation of this manifest as a Hash, used to populate
    # request bodies when directing, rendering, etc.
    # @return [Hash] the manifest as a Hash
    def to_hash
      {}
    end
    
    # Returns a representation of this manifest as JSON.
    # @return [String] the manifest as JSON
    def to_json
      self.to_hash.to_json
    end
    
  end
end