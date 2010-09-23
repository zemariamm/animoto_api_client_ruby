module Animoto
  module Assets
    class Image < Animoto::Assets::Base
      include Support::Visual
      include Support::Coverable

      attr_accessor :rotation
    
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