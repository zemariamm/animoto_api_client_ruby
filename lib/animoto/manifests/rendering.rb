module Animoto
  module Manifests
    class Rendering < Animoto::Manifests::Base
    
      # The vertical resolution of the rendered video. Valid values are '180p', '240p',
      # '360p', '480p', '720p' or '1080p'.
      # @return [String]
      attr_accessor :resolution
      
      # The framerate of the rendered video. Valid values are 12, 15, 24 or 30.
      # @return [Fixnum]
      attr_accessor :framerate
      
      # The format of the rendered video. Valid values are 'h264', 'h264-iphone', 'flv' or 'iso'.
      # @return [String]
      attr_accessor :format
      
      # The storyboard this rendering targets.
      # @return [Assets::Storyboard]
      attr_accessor :storyboard
      
      # A URL to receive a callback after directing is finished.
      # @return [String]
      attr_accessor :http_callback_url
      
      # The format of the callback; either 'xml' or 'json'.
      # @return [String]
      attr_accessor :http_callback_format
      
      # Creates a new rendering manifest.
      #
      # @param [Resources::Storyboard] storyboard the storyboard for this rendering
      # @param [Hash<Symbol,Object>] options
      # @option options [String] :resolution the vertical resolution of the rendered video
      # @option options [Integer] :framerate the framerate of the rendered video
      # @option options [String] :format the format of the rendered video
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      # @return [Manifests::Rendering] the manifest
      def initialize storyboard, options = {}
        @storyboard = storyboard
        @resolution = options[:resolution]
        @framerate  = options[:framerate]
        @format     = options[:format]
        @http_callback_url = options[:http_callback_url]
        @http_callback_format = options[:http_callback_format]
      end
    
      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash<String,String>] this manifest as a Hash
      # @raise [ArgumentError] if a callback URL was specified but not the format
      def to_hash
        hash  = { 'rendering_job' => { 'rendering_manifest' => { 'rendering_parameters' => {} } } }
        job   = hash['rendering_job']
        if http_callback_url
          raise ArgumentError, "You must specify a http_callback_format (either 'xml' or 'json')" if http_callback_format.nil?
          job['http_callback'] = http_callback_url
          job['http_callback_format'] = http_callback_format
        end
        manifest = job['rendering_manifest']
        manifest['storyboard_url'] = storyboard.url
        params = manifest['rendering_parameters']
        params['resolution'] = resolution
        params['framerate'] = framerate
        params['format'] = format
        hash
      end    
    end
  end
end