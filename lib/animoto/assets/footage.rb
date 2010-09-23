module Animoto
  module Assets
    class Footage < Animoto::Assets::Base
      include Support::Visual
      include Support::Coverable
    
      attr_accessor :audio_mix, :start_time, :duration
    
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