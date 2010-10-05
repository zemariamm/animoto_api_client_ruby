module Animoto
  module Assets
    class Song < Animoto::Assets::Base
      
      # The offset in seconds from the beginning denoting where to start
      # using this song in the video.
      # @return [Float]
      attr_accessor :start_time
      
      # The duration in seconds of how long this song should play.
      # @return [Float]
      attr_accessor :duration
    
      # Returns a representation of this Song as a Hash.
      #
      # @return [Hash<String,Object>] this asset as a Hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['start_time'] = start_time if start_time
        hash['duration'] = duration if duration
        hash
      end
    
    end
  end
end