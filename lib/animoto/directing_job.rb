module Animoto
  class DirectingJob < Animoto::Job
    
    endpoint '/jobs/directing'
    
    attr_reader :storyboard, :storyboard_url
    
    def initialize body = {}
      super
      @storyboard_url = body['payload'][payload_key]['links']['storyboard']
      @storyboard = Animoto::Storyboard.new(:url => @storyboard_url) if @storyboard_url
    end
    
  end
end