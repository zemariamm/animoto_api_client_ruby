module Animoto
  class Song < Animoto::Asset
    
    attr_accessor :start_time, :duration
    
    def to_hash
      hash = super
      hash['start_time'] = start_time if start_time
      hash['duration'] = duration if duration
      hash
    end
    
  end
end