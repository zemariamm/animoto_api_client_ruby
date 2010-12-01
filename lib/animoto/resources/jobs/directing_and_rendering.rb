module Animoto
  module Resources
    module Jobs
      class DirectingAndRendering < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/directing_and_rendering'

        # @return [Hash{Symbol=>Object}]
        # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body = {}
          links = unpack_links(body)
          super.merge({
            :storyboard_url => links['storyboard'],
            :video_url      => links['video']
          })
        end

        # The URL for the storyboard created for this job. This storyboard can be
        # used into future rendering jobs to produce different formats, resolutions,
        # etc.
        # @return [String]
        attr_reader :storyboard_url
        
        # A Storyboard object for this job.
        # @return [Resources::Storyboard]
        attr_reader :storyboard
        
        # The URL for the video created. Note that this is for the video *resource* and not
        # the URL to the actual video *file* (though requesting the resource will give you
        # the URL to the file).
        # @return [String]
        attr_reader :video_url
        
        # A Video object for this job.
        #
        # @note this object may not have all the most recent attributes, namely the download_url
        #   attribute. Use {Client#reload!} to update the object.
        # @return [Resources::Video]
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