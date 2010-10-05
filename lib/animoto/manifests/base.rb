module Animoto
  module Manifests

    # @abstract
    class Base
      include Support::ContentType
    
      # Returns a representation of this manifest as a Hash, used to populate
      # request bodies when directing, rendering, etc.
      #
      # @return [Hash<String,Object>] the manifest as a Hash
      def to_hash
        {}
      end
    
    end
  end
end