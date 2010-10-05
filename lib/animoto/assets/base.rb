module Animoto
  module Assets

    # @abstract
    class Base
      
      # The URL of this asset.
      # @return [String]
      attr_accessor :source
      
      # Creates a new asset.
      #
      # @param [String] source the URL of this asset
      # @return [Assets::Base] the asset
      def initialize source, options = {}
        @source = source
      end
    
      # Returns a representation of this asset as a Hash. Used mainly for generating
      # manifests.
      #
      # @return [Hash<String,Object>] this asset as a Hash
      def to_hash
        { 'source_url' => @source }
      end

    end
  end
end