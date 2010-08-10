module Animoto
  class DirectingJob < Animoto::Job
    
    endpoint '/jobs/directing'

    def self.unpack_standard_envelope body
      super.merge(:storyboard_url => body['response']['payload'][payload_key]['links']['storyboard'])
    end
    
    attr_reader :storyboard, :storyboard_url

    def load attributes = {}
      @storyboard_url = attributes[:storyboard_url]
      @storyboard = Animoto::Storyboard.new(:url => @storyboard_url) if @storyboard_url
      super
    end
  end
end