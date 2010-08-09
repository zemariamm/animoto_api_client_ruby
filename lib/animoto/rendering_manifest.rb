module Animoto
  class RenderingManifest
    
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
    
    def to_hash
      hash  = { 'rendering_job' => { 'rendering_manifest' => { 'rendering_profile' => {} } } }
      job   = hash['rendering_job']
      if http_callback_url
        raise ArgumentError if http_callback_format.nil?
        job['http_callback'] = http_callback_url
        job['http_callback_format'] = http_callback_format
      end
      manifest = job['rendering_manifest']
      manifest['storyboard_url'] = storyboard.url
      profile = manifest['rendering_profile']
      profile['vertical_resolution'] = resolution
      profile['framerate'] = framerate
      profile['format'] = format
      hash
    end
    
    def to_json
      self.to_hash.to_json
    end
  end
end