module Animoto
  module Manifests
    class DirectingAndRendering < Animoto::Manifests::Directing
    
      attr_accessor :resolution, :framerate, :format
    
      def initialize options = {}
        super
        @resolution = options[:resolution]
        @framerate  = options[:framerate]
        @format     = options[:format]
      end
    
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