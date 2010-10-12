module Animoto
  module Manifests
    class DirectingAndRendering < Animoto::Manifests::Directing
      
      # The vertical resolution of the rendered video. Valid values are '180p', '270p',
      # '360p', '480p', '576p', '720p' or '1080p'.
      # @return [String]
      attr_accessor :resolution
      
      # The framerate of the rendered video. Valid values are 12, 15, 24 or 30.
      # @return [Fixnum]
      attr_accessor :framerate
      
      # The format of the rendered video. Valid values are 'h264', 'h264-iphone', 'flv' or 'iso'.
      # @return [String]
      attr_accessor :format
      
      # Creates a new directing-and-rendering manifest.
      #
      # @param [Hash<Symbol,Object>] options
      # @option options [String] :resolution the vertical resolution of the rendered video
      # @option options [Integer] :framerate the framerate of the rendered video
      # @option options [String] :format the format of the rendered video
      # @return [Manifests::DirectingAndRendering] the manifest
      # @see Animoto::Manifests::Directing#initialize
      def initialize options = {}
        super
        @resolution = options[:resolution]
        @framerate  = options[:framerate]
        @format     = options[:format]
      end
    
      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash<String,String>] the manifest as a Hash
      # @raise [ArgumentError] if a callback URL is specified but not the format
      # @see Animoto::Manifests::Directing#to_hash
      def to_hash options = {}
        hash  = super
        directing_job = hash.delete('directing_job')
        hash['directing_and_rendering_job'] = directing_job.merge('rendering_manifest' => { 'rendering_parameters' => {}})
        params = hash['directing_and_rendering_job']['rendering_manifest']['rendering_parameters']
        params['resolution'] = resolution
        params['framerate'] = framerate
        params['format'] = format
        hash
      end
    
    end
  end
end