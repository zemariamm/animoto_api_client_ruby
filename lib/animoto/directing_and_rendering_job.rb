module Animoto
  class DirectingAndRenderingJob < Animoto::Job
    
    endpoint '/jobs/directing_and_rendering'
    
    attr_reader :video, :video_url
    
    def initialize body = {}
      super
      @video_url = body['payload'][payload_key]['links']['video']
      @video = Animoto::Video.new(:url => @video_url) if @video_url
    end
    
  end
end