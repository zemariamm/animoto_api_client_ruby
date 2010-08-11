require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'yaml'

require 'animoto/errors'
require 'animoto/content_type'
require 'animoto/standard_envelope'
require 'animoto/resource'
require 'animoto/asset'
require 'animoto/visual'
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
    API_ENDPOINT      = "http://api2-staging.animoto.com/"
    API_VERSION       = 1
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    HTTP_METHOD_MAP   = {
      :get  => Net::HTTP::Get,
      :post => Net::HTTP::Post
    }
    
    attr_accessor :key, :secret
    attr_reader   :format
    
    # Creates a new Client object which handles credentials, versioning, making requests, and
    # parsing responses.
    #
    # If you have your key and secret in ~/.animotorc or /etc/.animotorc, those credentials will
    # be read from those files (in that order) whenever you make a new Client if you don't specify
    # them explicitly.
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
      unless @key && @secret
        home_path = File.expand_path '~/.animotorc'
        config = if File.exist?(home_path)
          YAML.load(File.read(home_path))
        elsif File.exist?('/etc/.animotorc')
          YAML.load(File.read('/etc/.animotorc'))
        end
        if config
          @key ||= config['key']
          @secret ||= config['secret']
        else
          raise ArgumentError, "You must supply your key and secret"
        end
      end
      @format = 'json'
      uri = URI.parse(API_ENDPOINT)
      @http = Net::HTTP.new uri.host, uri.port
      # @http.use_ssl = true
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
    
    # Builds a request to find a resource.
    #
    # @param [Class] klass the Resource class you're looking for
    # @param [String] url the URL of the resource
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def find_request klass, url, options = {}
      request(:get, URI.parse(url).path, nil, { "Accept" => content_type_of(klass) }, options)
    end
    
    # Builds a request requiring a manifest.
    #
    # @param [Manifest] manifest the manifest being acted on
    # @param [String] endpoint the endpoint to send the request to
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def send_manifest manifest, endpoint, options = {}
      request(:post, endpoint, manifest.to_json, { "Accept" => "application/#{format}", "Content-Type" => content_type_of(manifest) }, options)
    end
    
    # Makes a request and parses the response.
    #
    # @param [Symbol] method which HTTP method to use (should be lowercase, i.e. :get instead of :GET)
    # @param [String] uri the request path
    # @param [String, nil] body the request body
    # @param [Hash<String,String>] headers the request headers (will be sent as-is, which means you should
    #   specify "Content-Type" => "..." instead of, say, :content_type => "...")
    # @param [Hash] options
    # @return [Hash] deserialized JSON response body
    def request method, uri, body, headers = {}, options = {}
      req = build_request method, uri, body, headers, options
      read_response @http.request(req)
    end
    
    # Builds the request object.
    #
    # @param [Symbol] method which HTTP method to use (should be lowercase, i.e. :get instead of :GET)
    # @param [String] uri the request path
    # @param [String, nil] body the request body
    # @param [Hash<String,String>] headers the request headers (will be sent as-is, which means you should
    #   specify "Content-Type" => "..." instead of, say, :content_type => "...")
    # @param [Hash] options
    # @return [Net::HTTPRequest] the request object
    def build_request method, uri, body, headers, options
      req = HTTP_METHOD_MAP[method].new uri
      req.body = body
      req.initialize_http_header headers
      req.basic_auth key, secret
      req
    end

    # Verifies and parses the response.
    #
    # @param [Net::HTTPResponse] response the response object
    # @return [Hash] deserialized JSON response body
    def read_response response
      check_status response
      parse_response response
    end
    
    # Checks the status of the response to make sure it's successful.
    #
    # @param [Net::HTTPResponse] response the response object
    # @return [nil]
    # @raise [Error,RuntimeError] if the response code isn't in the 200 range
    def check_status response
      unless (200..299).include?(response.code.to_i)
        if response.body
          begin
            json = JSON.parse(response.body)
            errors = json['response']['status']['errors']
          rescue => e
            raise response.message
          else
            raise Animoto::Error.new(errors.collect { |e| e['message'] }.join(', '))
          end
        else
          raise response.message
        end
      end
    end
    
    # Parses a JSON response body into a Hash.
    # @param [Net::HTTPResponse] response the response object
    # @return [Hash] deserialized JSON response body
    def parse_response response
      JSON.parse(response.body)
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