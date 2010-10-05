module Animoto
  module Resources
    class Video < Animoto::Resources::Base
    
      # @return [Hash<Symbol,Object>]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
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

      attr_reader :download_url
      attr_reader :storyboard_url
      attr_reader :storyboard
      attr_reader :duration
      attr_reader :format
      attr_reader :framerate
      attr_reader :resolution

      # Sets the attributes on a new video.
      #
      # @param [Hash<Symbol,Object>] attributes
      # @option attributes [String] :download_url the URL where this video can be downloaded
      # @option attributes [String] :storyboard_url the URL for this video's storyboard
      # @option attributes [Integer] :duration the duration (in seconds) of this video
      # @option attributes [String] :format the format of this video
      # @option attributes [Integer] :framerate the framerate of this video
      # @option attributes [String] :resolution the vertical resolution of this video
      # @return [Resources::Video] the video
      # @see Animoto::Resources::Base#instantiate
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