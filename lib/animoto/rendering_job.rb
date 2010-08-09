module Animoto
  class RenderingJob < Animoto::Job
    
    endpoint '/jobs/rendering'

    def self.unpack_standard_envelope body
      super.merge({
        :storyboard_url => body['payload'][payload_key]['links']['storyboard'],
        :video_url      => body['payload'][payload_key]['links']['video']
      })
    end
    
    attr_reader :storyboard, :storyboard_url, :video, :video_url
    
    def initialize options = {}
      super
      @storyboard_url = options[:storyboard_url]
      @storyboard = Animoto::Storyboard.new(:url => @storyboard_url) if @storyboard_url
      @video_url = options[:video_url]
      @video = Animoto::Video.new(:url => @video_url) if @video_url
    end
        
  end
end