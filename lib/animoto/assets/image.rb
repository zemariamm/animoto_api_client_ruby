module Animoto
  module Assets
    class Image < Animoto::Assets::Base
      include Support::Visual
      include Support::Coverable

      # The EXIF rotation value for how this image should be rotated in the video.
      # @return [Integer]
      attr_accessor :rotation
    
      # Returns a representation of this Image as a Hash.
      #
      # @return [Hash{String=>Object}] this asset as a Hash
      # @see Animoto::Support::Visual#to_hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['rotation'] = rotation if rotation
        hash['spotlit'] = spotlit? unless @spotlit.nil?
        hash['cover'] = cover? unless @cover.nil?
        hash
      end
    end
  end
end