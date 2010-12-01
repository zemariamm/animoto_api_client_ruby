module Animoto
  module Resources
    module Jobs
      class Rendering < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/rendering'

        # @return [Hash{Symbol=>Object}]
        # @see Animoto::Support::StandardEvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body
          links = unpack_links(body)
          super.merge({
            :storyboard_url => links['storyboard'],
            :video_url      => links['video']
          })
        end
    
        # The Storyboard this job will render a video from.
        # @return [Resources::Storyboard]
        attr_reader :storyboard
        
        # The URL to the storyboard resource.
        # @return [String]
        attr_reader :storyboard_url
        
        # The Video created by this job.
        # @return [Resources::Video]
        attr_reader :video
        
        # The URL to the video resource.
        #
        # @note This URL points to the video *resource* and not the actual video *file*.
        # @return [String]
        attr_reader :video_url
    
        # @return [Jobs::Rendering]
        # @see Animoto::Jobs::Base#instantiate
        def instantiate attributes = {}
          @storyboard_url = attributes[:storyboard_url]
          @storyboard = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
          @video_url = attributes[:video_url]
          @video = Animoto::Resources::Video.new(:url => @video_url) if @video_url
          super
        end
        
      end
    end
  end
end