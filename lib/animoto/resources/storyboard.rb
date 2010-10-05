module Animoto
  module Resources
    class Storyboard < Animoto::Resources::Base
      
      # @return [Hash<Symbol,Object>]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
      def self.unpack_standard_envelope body = {}
        super.merge({
          :duration => body['response']['payload'][payload_key]['metadata']['duration'],
          :visuals_count => body['response']['payload'][payload_key]['metadata']['visuals_count'],
          :preview_url => body['response']['payload'][payload_key]['links']['preview']
        })
      end
    
      attr_reader :duration
      attr_reader :visuals_count
      attr_reader :preview_url
      
      # Sets the attributes for a new storyboard.
      #
      # @param [Hash] attributes
      # @option attributes [Integer] :duration the duration (in seconds) the rendered video will be
      # @option attributes [Integer] :visuals_count the number of visuals the rendered video will have
      # @option attributes [String] :preview_url URL to a low-resolution preview of the rendered video
      # @return [Resources::Storyboard] the storyboard
      # @see Animoto::Resources::Base#instantiate
      def instantiate attributes = {}
        @duration = attributes[:duration]
        @visuals_count = attributes[:visuals_count]
        @preview_url = attributes[:preview_url]
        super
      end
        
    end
  end
end