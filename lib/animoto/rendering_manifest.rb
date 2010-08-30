module Animoto
  class RenderingManifest < Animoto::Manifest
    
    attr_accessor :storyboard, :resolution, :framerate, :format,
      :http_callback_url, :http_callback_format
      
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
    # @return [Hash] this manifest as a Hash
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