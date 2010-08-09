module Animoto
  class Song < Animoto::Asset
    
    attr_accessor :start_time, :duration, :title, :artist
    
    def to_hash
      hash = super
      hash['start_time'] = start_time if start_time
      hash['duration'] = duration if duration
      hash['title'] = title if title
      hash['artist'] = artist if artist
      hash
    end
    
  end
end