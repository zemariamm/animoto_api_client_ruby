module Animoto
  module Resources
    module Jobs
      class DirectingAndRendering < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/directing_and_rendering'

        def self.unpack_standard_envelope body = {}
          links = unpack_links(body)
          super.merge({
            :storyboard_url => links['storyboard'],
            :video_url      => links['video']
          })
        end

        attr_reader :storyboard_url
        attr_reader :storyboard
        attr_reader :video_url
        attr_reader :video

        # @return [Jobs::DirectingAndRendering]
        # @see Animoto::Jobs::Base#instantiate
        def instantiate attributes = {}
          @storyboard_url = attributes[:storyboard_url]
          @storyboard     = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
          @video_url      = attributes[:video_url]
          @video          = Animoto::Resources::Video.new(:url => @video_url) if @video_url
          super
        end
    
      end
    end
  end
end