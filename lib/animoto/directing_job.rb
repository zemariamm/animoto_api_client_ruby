module Animoto
  class DirectingJob < Animoto::Job
    
    endpoint '/jobs/directing'

    def self.unpack_standard_envelope body
      super.merge(:storyboard_url => body['payload'][payload_key]['links']['storyboard'])
    end
    
    attr_reader :storyboard, :storyboard_url
    
    def initialize options = {}
      super
      @storyboard_url = options[:storyboard_url]
      @storyboard = Animoto::Storyboard.new(:url => @storyboard_url) if @storyboard_url
    end
    
  end
end