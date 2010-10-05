module Animoto
  module Support
    module Coverable
    
      # Setter for cover, which makes this visual the cover for the video. Only
      # one image or piece of footage in a manifest can be declared the cover.
      #
      # @param [Boolean] bool true if this visual should be the cover
      def cover= bool
        @cover = bool
      end
    
      # Returns true if this visual is the cover.
      #
      # @return [Boolean] whether or not this visual is the cover
      def cover?
        @cover
      end
    
      # Returns a representation of this visual as a Hash.
      #
      # @return [Hash<String,Object>] this visual as a Hash
      def to_hash
        hash = super rescue {}
        hash['cover'] = cover? unless @cover.nil?
        hash
      end
    
    end
  end
end