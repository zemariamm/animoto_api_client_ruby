module Animoto
  module Resources
    class Video < Animoto::Resources::Base
    
      def self.unpack_standard_envelope body
        super.merge({
          :download_url => body['response']['payload'][payload_key]['links']['file'],
          :storyboard_url => body['response']['payload'][payload_key]['links']['storyboard'],
          :duration => body['response']['payload'][payload_key]['metadata']['duration'],
          :format   => body['response']['payload'][payload_key]['metadata']['format'],
          :framerate  => body['response']['payload'][payload_key]['metadata']['framerate'],
          :resolution => body['response']['payload'][payload_key]['metadata']['vertical_resolution']
        })
      end

      attr_reader :download_url, :storyboard_url, :storyboard, :duration, :format, :framerate, :resolution

      def instantiate attributes = {}
        @download_url = attributes[:download_url]
        @storyboard_url = attributes[:storyboard_url]
        @storyboard = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
        @duration = attributes[:duration]
        @format = attributes[:format]
        @framerate = attributes[:framerate]
        @resolution = attributes[:resolution]
        super
      end

    end
  end
end