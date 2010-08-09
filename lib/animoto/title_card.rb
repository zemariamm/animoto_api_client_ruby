module Animoto
  class TitleCard
    include Animoto::Visual
    
    attr_accessor :title, :subtitle
    
    def initialize title, subtitle = nil
      @title, @subtitle = title, subtitle
    end
    
    def to_hash
      hash = super
      hash['h1'] = title
      hash['h2'] = subtitle if subtitle
      hash['spotlit'] = spotlit? unless @spotlit.nil?
      hash
    end
  end
end