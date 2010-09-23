module Animoto
  module Assets
    class Base
    
      attr_accessor :source
    
      def initialize source, options = {}
        @source = source
      end
    
      # Returns a representation of this asset as a Hash. Used mainly for generating
      # manifests.
      #
      # @return [Hash] this asset as a Hash
      def to_hash
        { 'source_url' => @source }
      end

    end
  end
end