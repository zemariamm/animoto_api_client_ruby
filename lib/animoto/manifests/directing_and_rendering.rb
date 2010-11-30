module Animoto
  module Manifests
    
    # A directing-and-rendering manifest is little more than just a single envelope
    # with a directing manifest and a rendering manifest embedded within.
    class DirectingAndRendering < Animoto::Manifests::Base
      
      # The embedded directing manifest
      # @return [Manifests::Directing]
      attr_reader :directing_manifest
      
      # The embedded rendering manifest
      # @return [Manifests::Rendering]
      attr_reader :rendering_manifest

      # A URL to receive a callback after directing is finished.
      # @return [String]
      attr_accessor :http_callback_url
      
      # The format of the callback; either 'xml' or 'json'.
      # @return [String]
      attr_accessor :http_callback_format

      # Creates a new directing-and-rendering manifest.
      #
      # @param [Hash<Symbol,Object>] options
      # @option options [String] :title the title of this project
      # @option options [String] :pacing ('default') the pacing for this project
      # @option options [String] :resolution the vertical resolution of the rendered video
      # @option options [Integer] :framerate the framerate of the rendered video
      # @option options [String] :format the format of the rendered video
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      def initialize options = {}        
        @directing_manifest = Manifests::Directing.new(options.only(:title, :pacing))
        @rendering_manifest = Manifests::Rendering.new(options.only(:resolution, :framerate, :format))
        
        @http_callback_url  = options[:http_callback_url]
        @http_callback_format = options[:http_callback_format]
      end

      # Delegates method calls to the underlying directing or rendering manifests if
      # they respond to the call.
      #
      # @raise [NoMethodError] if the underlying manifests don't respond
      def method_missing *args
        name = args.first
        if directing_manifest.respond_to?(name)
          directing_manifest.__send__ *args
        elsif rendering_manifest.respond_to?(name)
          rendering_manifest.__send__ *args
        else
          super
        end
      end

      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash<String,String>] the manifest as a Hash
      # @raise [ArgumentError] if a callback URL is specified but not the format
      # @see Animoto::Manifests::Directing#to_hash
      # @see Animoto::Manifests::Rendering#to_hash
      def to_hash options = {}
        hash  = { 'directing_and_rendering_job' => {} }
        job   = hash['directing_and_rendering_job']
        if http_callback_url
          raise ArgumentError, "You must specify a http_callback_format (either 'xml' or 'json')" if http_callback_format.nil?
          job['http_callback'] = http_callback_url
          job['http_callback_format'] = http_callback_format
        end
        job['directing_manifest'] = self.directing_manifest.to_hash['directing_job']['directing_manifest']
        job['rendering_manifest'] = self.rendering_manifest.to_hash['rendering_job']['rendering_manifest']
        hash
      end
    
    end
  end
end