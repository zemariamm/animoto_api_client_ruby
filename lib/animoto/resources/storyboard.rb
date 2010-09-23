module Animoto
  module Resources
    class Storyboard < Animoto::Resources::Base
    
      def self.unpack_standard_envelope body = {}
        super.merge({
          :duration => body['response']['payload'][payload_key]['metadata']['duration'],
          :visuals_count => body['response']['payload'][payload_key]['metadata']['visuals_count'],
          :preview_url => body['response']['payload'][payload_key]['links']['preview']
        })
      end
    
      attr_reader :duration, :visuals_count, :preview_url
    
      def instantiate attributes = {}
        @duration = attributes[:duration]
        @visuals_count = attributes[:visuals_count]
        @preview_url = attributes[:preview_url]
        super
      end
        
    end
  end
end