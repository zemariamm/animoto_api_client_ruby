module Animoto
  class RenderingJob < Animoto::Job
    
    endpoint '/jobs/rendering'
    
    attr_reader :storyboard, :storyboard_url, :video, :video_url
    
    def initialize body = {}
      super
      @storyboard_url = body['payload'][payload_key]['links']['storyboard']
      @storyboard = Animoto::Storyboard.new(:url => @storyboard_url) if @storyboard_url
      @video_url = body['payload'][payload_key]['links']['video']
      @video = Animoto::Video.new(:url => @video_url) if @video_url
    end
        
  end
end