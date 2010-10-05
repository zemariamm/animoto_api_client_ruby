module Animoto
  module Resources
    module Jobs
      class Rendering < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/rendering'

        # @return [Hash<Symbol,Object>]
        # @see Animoto::Support::StandardEvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body
          super.merge({
            :storyboard_url => body['response']['payload'][payload_key]['links']['storyboard'],
            :video_url      => body['response']['payload'][payload_key]['links']['video']
          })
        end
    
        attr_reader :storyboard
        attr_reader :storyboard_url
        attr_reader :video
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