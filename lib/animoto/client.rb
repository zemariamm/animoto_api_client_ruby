require 'yaml'
require 'uri'
require 'logger'

require 'animoto/support/content_type'
require 'animoto/support/coverable'
require 'animoto/support/dynamic_class_loader'
require 'animoto/support/errors'
require 'animoto/support/standard_envelope'
require 'animoto/support/visual'

require 'animoto/resources/base'
require 'animoto/resources/storyboard'
require 'animoto/resources/video'
require 'animoto/resources/jobs/base'
require 'animoto/resources/jobs/directing_and_rendering'
require 'animoto/resources/jobs/directing'
require 'animoto/resources/jobs/rendering'

require 'animoto/assets/base'
require 'animoto/assets/footage'
require 'animoto/assets/image'
require 'animoto/assets/song'
require 'animoto/assets/title_card'

require 'animoto/manifests/base'
require 'animoto/manifests/directing'
require 'animoto/manifests/directing_and_rendering'
require 'animoto/manifests/rendering'

require 'animoto/callbacks/base'
require 'animoto/callbacks/directing'
require 'animoto/callbacks/directing_and_rendering'
require 'animoto/callbacks/rendering'

require 'animoto/http_engines/base'
require 'animoto/response_parsers/base'
require 'animoto/response_parsers/abstract_xml_adapter'

module Animoto
  class Client
    API_ENDPOINT      = "https://api2-sandbox.animoto.com/"
    API_VERSION       = 1
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    
    attr_accessor :key, :secret, :endpoint, :logger
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
      options = args.last.is_a?(Hash) ? args.pop : {}
      @key      = args[0]
      @secret   = args[1]
      @endpoint = options[:endpoint]
      @logger   = options[:logger] || ::Logger.new(STDOUT)
      configure_from_rc_file
      @endpoint ||= API_ENDPOINT
      __send__ :http_engine=, options[:http_engine] || :net_http
      __send__ :response_parser=, options[:response_parser] || :json
    end
    
    # Set the HTTP engine this client will use.
    # 
    # @param [HTTPEngines::Base, Symbol, Class] engine you may pass a
    #   HTTPEngine instance to use, or the symbolic name of a adapter to use,
    #   or a Class whose instances respond to #request and return a String of
    #   the response body
    # @see Animoto::HTTPEngines::Base
    # @return [HTTPEngines::Base] the engine instance
    # @raise [ArgumentError] if given a class without the correct interface
    def http_engine= engine
      @http_engine = case engine
      when Animoto::HTTPEngines::Base
        engine
      when Class
        if engine.instance_methods.include?('request')
          engine.new
        else
          raise ArgumentError
        end
      else
        Animoto::HTTPEngines[engine].new
      end
    end
    
    # Set the response parser this client will use.
    # 
    # @param [ResponseParsers::Base, Symbol, Class] parser you may pass a
    #   ResponseParser instance to use, or the symbolic name of a adapter to use,
    #   or a Class whose instances respond to #parse, #unparse, and #format.
    # @see Animoto::ResponseParsers::Base
    # @return [ResponseParsers::Base] the parser instance
    # @raise [ArgumentError] if given a class without the correct interface
    def response_parser= parser
      @response_parser = case parser
      when Animoto::ResponseParsers::Base
        parser
      when Class
        if %{format parse unparse}.all? { |m| parser.instance_methods.include? m }
          parser.new
        else
          raise ArgumentError
        end
      else
        Animoto::ResponseParsers[parser].new
      end
    end
    
    # Finds a resource by its URL.
    #
    # @param [Class] klass the resource class you're finding
    # @param [String] url the URL of the resource you want
    # @param [Hash] options
    # @return [Resources::Base] the resource object found
    def find klass, url, options = {}
      klass.load(find_request(klass, url, options))
    end
    
    # Returns a callback object of the specified type given the callback body.
    #
    # @param [Class] klass the callback class
    # @param [String] body the HTTP body of the callback
    # @return [Callbacks::Base] the callback object
    def process_callback klass, body
      klass.new(response_parser.parse(body))
    end
    
    # Sends a request to start directing a storyboard.
    #
    # @param [Manifests::Directing] manifest the manifest to direct
    # @param [Hash] options
    # @return [Jobs::Directing] a job to monitor the status of the directing
    def direct! manifest, options = {}
      Resources::Jobs::DirectingJob.load(send_manifest(manifest, Resources::Jobs::DirectingJob.endpoint, options))
    end
    
    # Sends a request to start rendering a video.
    #
    # @param [Manifests::Rendering] manifest the manifest to render
    # @param [Hash] options
    # @return [Jobs::Rendering] a job to monitor the status of the rendering
    def render! manifest, options = {}
      Resources::Jobs::RenderingJob.load(send_manifest(manifest, Resources::Jobs::RenderingJob.endpoint, options))
    end
    
    # Sends a request to start directing and rendering a video.
    #
    # @param [Manifests::DirectingAndRendering] manifest the manifest to direct and render
    # @param [Hash] options
    # @return [Jobs::DirectingAndRendering] a job to monitor the status of the directing and rendering
    def direct_and_render! manifest, options = {}
      Resources::Jobs::DirectingAndRenderingJob.load(send_manifest(manifest, Resources::Jobs::DirectingAndRenderingJob.endpoint, options))
    end
    
    # Update a resource with the latest attributes. Useful to update the state of a Job to
    # see if it's ready if you are not using HTTP callbacks.
    #
    # @param [Resources::Base] resource the resource to update
    # @param [Hash] options
    # @return [Resources::Base] the given resource with the latest attributes
    def reload! resource, options = {}
      resource.load(find_request(resource.class, resource.url, options))
    end
    
    private
    
    # Sets the API credentials from an .animotorc file. First looks for one in the current
    # directory, then checks ~/.animotorc, then finally /etc/.animotorc.
    #
    # @raise [ArgumentError] if none of the files are found
    def configure_from_rc_file
      current_path = Dir.pwd + '/.animotorc'
      home_path    = File.expand_path('~/.animotorc')
      config = if File.exist?(current_path)
        YAML.load(File.read(current_path))
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
      end
      @key && @secret ? return : raise(ArgumentError, "You must supply your key and secret")
    end

    # Builds a request to find a resource.
    #
    # @param [Class] klass the Resource class you're looking for
    # @param [String] url the URL of the resource
    # @param [Hash] options
    # @return [Hash] deserialized response body
    def find_request klass, url, options = {}
      request(:get, url, nil, { "Accept" => content_type_of(klass) }, options)
    end
    
    # Builds a request requiring a manifest.
    #
    # @param [Manifests::Base] manifest the manifest being acted on
    # @param [String] endpoint the endpoint to send the request to
    # @param [Hash] options
    # @return [Hash] deserialized response body
    def send_manifest manifest, endpoint, options = {}
      u = URI.parse(self.endpoint)
      u.path = endpoint
      request(
        :post,
        u.to_s,
        response_parser.unparse(manifest.to_hash),
        { "Accept" => "application/#{response_parser.format}", "Content-Type" => content_type_of(manifest) },
        options
      )
    end
    
    # Makes a request and parses the response.
    #
    # @param [Symbol] method which HTTP method to use (should be lowercase, i.e. :get instead of :GET)
    # @param [String] url the URL of the request
    # @param [String, nil] body the request body
    # @param [Hash<String,String>] headers the request headers (will be sent as-is, which means you should
    #   specify "Content-Type" => "..." instead of, say, :content_type => "...")
    # @param [Hash] options
    # @return [Hash] deserialized response body
    # @raise [Error]
    def request method, url, body, headers = {}, options = {}
      code, body = catch(:fail) do
        options = { :username => @key, :password => @secret }.merge(options)
        @logger.info "Sending request to #{url.inspect} with body #{body}"
        response = http_engine.request(method, url, body, headers, options)
        @logger.info "Received response #{response}"
        return response_parser.parse(response)
      end
      if code
        if body.empty?
          @logger.error "HTTP error (#{code})"
          raise Animoto::Error.new("HTTP error (#{code})")
        else
          errors = response_parser.parse(body)['response']['status']['errors']
          err_string = errors.collect { |e| e['message'] }.join(', ')
          @logger.error "Error response from server: #{err_string}"
          raise Animoto::Error.new(err_string)
        end
      else
        @logger.error "Error sending request to #{url.inspect}"
        raise Animoto::Error
      end
    rescue NoMethodError => e
      @logger.error e.inspect
      raise Animoto::Error.new("Invalid response (#{e.inspect})")
    end
    
    # Creates the full content type string given a Resource class or instance
    # @param [Class,Support::ContentType] klass_or_instance the class or instance to build the
    #   content type for
    # @return [String] the full content type with the version and format included (i.e.
    #   "application/vnd.animoto.storyboard-v1+json")
    def content_type_of klass_or_instance
      klass = klass_or_instance.is_a?(Class) ? klass_or_instance : klass_or_instance.class
      "#{BASE_CONTENT_TYPE}.#{klass.content_type}-v#{API_VERSION}+#{response_parser.format}"
    end
    
  end
end