module Animoto
  module Resources
    class Video < Animoto::Resources::Base

      # @private
      # @return [Hash{String=>Object}]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
      def self.unpack_rendering_parameters body
        (unpack_payload(body)['metadata'] || {})['rendering_parameters']
      end
    
      # @return [Hash{Symbol=>Object}]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
      def self.unpack_standard_envelope body
        links = unpack_links(body)
        params = unpack_rendering_parameters(body)
        super.merge({
          :download_url   => links['file'],
          :storyboard_url => links['storyboard'],
          :format         => params['format'],
          :framerate      => params['framerate'],
          :resolution     => params['resolution']
        })
      end

      # The URL to the video file.
      # @return [String]
      attr_reader :download_url
      
      # The URL to the storyboard resource this video was rendered from.
      # @return [String]
      attr_reader :storyboard_url
      
      # The Storyboard object this video was rendered from.
      # @return [Resources::Storyboard]
      attr_reader :storyboard
      
      # The format of the video.
      # @return [String]
      attr_reader :format
      
      # The framerate of the video.
      # @return [Integer]
      attr_reader :framerate
      
      # The resolution of the video.
      # @return [String]
      attr_reader :resolution

      # Sets the attributes on a new video.
      #
      # @param [Hash{Symbol=>Object}] attributes
      # @option attributes [String] :download_url the URL where this video can be downloaded
      # @option attributes [String] :storyboard_url the URL for this video's storyboard
      # @option attributes [String] :format the format of this video
      # @option attributes [Integer] :framerate the framerate of this video
      # @option attributes [String] :resolution the vertical resolution of this video
      # @return [Resources::Video] the video
      # @see Animoto::Resources::Base#instantiate
      def instantiate attributes = {}
        @download_url = attributes[:download_url]
        @storyboard_url = attributes[:storyboard_url]
        @storyboard = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
        @format = attributes[:format]
        @framerate = attributes[:framerate]
        @resolution = attributes[:resolution]
        super
      end

    end
  end
end