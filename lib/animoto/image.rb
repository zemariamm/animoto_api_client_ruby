module Animoto
  class Image < Animoto::Asset
    include Animoto::Visual

    attr_accessor :rotation
    
    def to_hash
      hash = super
      hash['rotation'] = rotation if rotation
      hash['spotlit'] = spotlit? unless @spotlit.nil?
      hash
    end
  end
end