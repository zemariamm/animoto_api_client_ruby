module Animoto
  module Resources
    module Jobs
      class DirectingAndRendering < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/directing_and_rendering'

        def self.unpack_standard_envelope body
          super.merge(:video_url => body['response']['payload'][payload_key]['links']['video'])
        end
    
        attr_reader :video, :video_url
    
        def instantiate attributes = {}
          @video_url = attributes[:video_url]
          @video = Animoto::Resources::Video.new(:url => @video_url) if @video_url
          super
        end
    
      end
    end
  end
end