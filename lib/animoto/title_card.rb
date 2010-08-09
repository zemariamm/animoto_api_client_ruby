module Animoto
  class TitleCard
    include Animoto::Visual
    
    attr_accessor :title, :subtitle
    
    def initialize title, subtitle = nil
      @title, @subtitle = title, subtitle
    end
    
  end
end