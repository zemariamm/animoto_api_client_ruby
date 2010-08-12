require 'json'
require 'yaml'

require 'animoto/errors'
require 'animoto/content_type'
require 'animoto/standard_envelope'
require 'animoto/resource'
require 'animoto/asset'
require 'animoto/visual'
require 'animoto/coverable'
require 'animoto/footage'
require 'animoto/image'
require 'animoto/song'
require 'animoto/title_card'
require 'animoto/manifest'
require 'animoto/directing_manifest'
require 'animoto/rendering_manifest'
require 'animoto/directing_and_rendering_manifest'
require 'animoto/storyboard'
require 'animoto/video'
require 'animoto/job'
require 'animoto/directing_and_rendering_job'
require 'animoto/directing_job'
require 'animoto/rendering_job'

module Animoto
  class Client
    API_ENDPOINT      = "https://api2-staging.animoto.com/"
    API_VERSION       = 1
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    
    attr_accessor :key, :secret, :endpoint
    attr_reader :http_engine, :response_parser
    
    # Creates a new Client object which handles credentials, versioning, making requests, and
    # parsing responses.
    #
    # If you have your key and secret in ~/.animotorc or /etc/.animotorc, those credentials will
    # be read from those files (in that order) whenever you make a new Client if you don't specify
    # them explicitly. You can also specify the endpoint (staging, sandbox, etc.) in the rc file.
    # The default endpoint will be used if one isn't specified.
    #
    # @param [String] key the API key for your account
    # @param [String] secret the secret key for your account
    # @return [Client]
    # @raise [ArgumentError] if no credentials are supplied
    def initialize *args
      @debug = ENV['DEBUG']
      options = args.last.is_a?(Hash) ? args.pop : {}
      @key = args[0]
      @secret = args[1]
      @endpoint = options[:endpoint]
      configure_from_rc_file
      @endpoint ||= API_ENDPOINT
      http_engine = options[:http_engine] || :NetHTTP
      response_parser = options[:response_parser] || :JSON
    end
    
    def http_engine= engine
      @http_engine = case engine
      when Animoto::HTTPEngine
        engine
      when Class
        if engine.instance_methods.include?('request')
          engine.new @base_url
        else
          raise ArgumentError
        end
      else
        Animoto::HTTPEngine[engine].new @base_url
      end
    end
    
    def response_parser= parser
      @response_parser = case parser
      when Animoto::ResponseParser
        parser
      when Class
        if %{format parse unparse}.all? { |m| parser.instance_methods.include? m }
          parser.new
        else
          raise ArgumentError
        end
      else
        Animoto::ResponseParser[parser].new
      end
    end
    
    # Finds a resource by its URL.
    #
    # @param [Class] klass the Resource class you're finding
    # @param [String] url the URL of the resource you want
    # @param [Hash] options
    # @return [Resource] the Resource object found
    def find klass, url, options = {}
      klass.load(find_request(klass, url, options))
    end
    
    # Sends a request to start directing a storyboard.
    #
    # @param [DirectingManifest] manifest the manifest to direct
    # @param [Hash] options
    # @return [DirectingJob] a job to monitor the status of the directing
    def direct! manifest, options = {}
      DirectingJob.load(send_manifest(manifest, DirectingJob.endpoint, options))
    end
    
    # Sends a request to start rendering a video.
    #
    # @param [RenderingManifest] manifest the manifest to render
    # @param [Hash] options
    # @return [RenderingJob] a job to monitor the status of the rendering
    def render! manifest, options = {}
      RenderingJob.load(send_manifest(manifest, RenderingJob.endpoint, options))
    end
    
    # Sends a request to start directing and rendering a video.
    #
    # @param [DirectingAndRenderingManifest] manifest the manifest to direct and render
    # @param [Hash] options
    # @return [DirectingAndRenderingJob] a job to monitor the status of the directing and rendering
    def direct_and_render! manifest, options = {}
      DirectingAndRenderingJob.load(send_manifest(manifest, DirectingAndRenderingJob.endpoint, options))
    end
    
    # Update a resource with the latest attributes. Useful to update the state of a Job to
    # see if it's ready if you are not using HTTP callbacks.
    #
    # @param [Resource] resource the resource to update
    # @param [Hash] options
    # @return [Resource] the given resource with the latest attributes
    def reload! resource, options = {}
      resource.load(find_request(resource.class, resource.url, options))
    end
    
    private
    
    # Sets the API credentials from an .animotorc file. First looks for one in the current
    # directory, then checks ~/.animotorc, then finally /etc/.animotorc.
    #
    # @raise [ArgumentError] if none of the files are found
    def configure_from_rc_file
      catch(:done) do
        current_path = Dir.pwd + '/.animotrc'
        config = if File.exist?(current_path)
          YAML.laod(File.read(current_path))
        elsif File.exist?(home_path)
          home_path = File.expand_path '~/.animotorc'
          YAML.load(File.read(home_path))
        elsif File.exist?('/etc/.animotorc')
          YAML.load(File.read('/etc/.animotorc'))
        end
        if config
          @key      ||= config['key']
          @secret   ||= config['secret']
          @endpoint ||= config['endpoint']
          throw :done if @key && @secret
        end
        raise ArgumentError, "You must supply your key and secret"
      end
    end

    # Builds a request to find a resource.
    #
    # @param [Class] klass the Resource class you're looking for
    # @param [String] url the URL of the resource
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def find_request klass, url, options = {}
      # request(:get, URI.parse(url).path, nil, { "Accept" => content_type_of(klass) }, options)
      request(:get, URI.parse(url), nil, { "Accept" => content_type_of(klass) }, options)
    end
    
    # Builds a request requiring a manifest.
    #
    # @param [Manifest] manifest the manifest being acted on
    # @param [String] endpoint the endpoint to send the request to
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def send_manifest manifest, endpoint, options = {}
      # request(:post, endpoint, manifest.to_json, { "Accept" => "application/#{format}", "Content-Type" => content_type_of(manifest) }, options)
      u = URI.parse(endpoint)
      u.path = endpoint
      request(:post, u, manifest.to_json, { "Accept" => "application/#{format}", "Content-Type" => content_type_of(manifest) }, options)
    end
    
    # Makes a request and parses the response.
    #
    # @param [Symbol] method which HTTP method to use (should be lowercase, i.e. :get instead of :GET)
    # @param [URI] uri a URI object of the request URI
    # @param [String, nil] body the request body
    # @param [Hash<String,String>] headers the request headers (will be sent as-is, which means you should
    #   specify "Content-Type" => "..." instead of, say, :content_type => "...")
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def request method, url, body, headers = {}, options = {}
      response_parser.parse(http_engine.request(method, url, body, headers, options))
    end
    
    # Creates the full content type string given a Resource class or instance
    # @param [Class,ContentType] klass_or_instance the class or instance to build the
    #   content type for
    # @return [String] the full content type with the version and format included (i.e.
    #   "application/vnd.animoto.storyboard-v1+json")
    def content_type_of klass_or_instance
      klass = klass_or_instance.is_a?(Class) ? klass_or_instance : klass_or_instance.class
      "#{BASE_CONTENT_TYPE}.#{klass.content_type}-v#{API_VERSION}+#{format}"
    end
    
  end
end