module Animoto
  module Assets
    class TitleCard
      include Support::Visual
      
      # The main text of this title card.
      # @return [String]
      attr_accessor :title
      
      # The secondary text of this title card.
      # @return [String]
      attr_accessor :subtitle
    
      # Creates a new TitleCard.
      #
      # @param [String] title the main text
      # @param [String] subtitle the secondary text
      def initialize title, subtitle = nil
        @title, @subtitle = title, subtitle
      end
    
      # Returns a representation of this TitleCard as a Hash.
      #
      # @return [Hash<String,Object>] this TitleCard as a Hash
      # @see Animoto::Support::Visual#to_hash
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