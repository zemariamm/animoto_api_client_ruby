module Animoto
  class Manifest
    include ContentType
    
    # Returns a representation of this manifest as a Hash, used to populate
    # request bodies when directing, rendering, etc.
    #
    # @return [Hash] the manifest as a Hash
    def to_hash
      {}
    end
    
  end
end