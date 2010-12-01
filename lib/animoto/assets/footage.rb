module Animoto
  module Assets
    class Footage < Animoto::Assets::Base
      include Support::Visual
      include Support::Coverable
      
      # Whether or not to mix the audio of this footage with the video's soundtrack.
      # @return [Boolean]
      attr_accessor :audio_mix
      
      # The time in seconds of where to start extracting a clip from this footage to
      # add to the video.
      # @return [Float]
      attr_accessor :start_time
      
      # The duration in seconds of how long this footage should run in the video.
      # @return [Float]
      attr_accessor :duration
    
      # Returns a representation of this Footage as a Hash.
      #
      # @return [Hash{String=>Object}] this asset as a Hash
      # @see Animoto::Support::Visual#to_hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['audio_mix'] = 'MIX' if audio_mix
        hash['start_time'] = start_time if start_time
        hash['duration'] = duration if duration
        hash 
      end
    end
  end
end