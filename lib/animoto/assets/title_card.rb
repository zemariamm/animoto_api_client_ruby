module Animoto
  module Assets
    class TitleCard
      include Support::Visual
    
      attr_accessor :title, :subtitle
    
      # Creates a new TitleCard.
      #
      # @param [String] title the main text
      # @param [String] subtitle the secondary text
      def initialize title, subtitle = nil
        @title, @subtitle = title, subtitle
      end
    
      # Returns a representation of this TitleCard as a Hash.
      #
      # @return [Hash] this TitleCard as a Hash
      def to_hash
        hash = super
        hash['h1'] = title
        hash['h2'] = subtitle if subtitle
        hash['spotlit'] = spotlit? unless @spotlit.nil?
        hash
      end
    end
  end
end