require 'uri'
require 'net/http'
require 'json'

$:.unshift File.dirname(__FILE__)
require 'errors'
require 'resource'
require 'asset'
require 'visual'
require 'footage'
require 'image'
require 'song'
require 'title_card'
require 'directing_manifest'
require 'rendering_manifest'
require 'directing_and_rendering_manifest'
require 'storyboard'
require 'video'
require 'job'
require 'directing_and_rendering_job'
require 'directing_job'
require 'rendering_job'

module Animoto
  class Client
    API_ENDPOINT      = "https://api.animoto.com"
    API_VERSION       = 1
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    HTTP_METHOD_MAP   = {
      :get  => Net::HTTP::Get,
      :post => Net::HTTP::Post
    }
    
    attr_accessor :username, :password
    attr_reader   :format
    
    def initialize *args
      options = args.last.is_a?(Hash) ? args.pop : {}
      @username = args[0]
      @password = args[1]
      unless @username && @password
        home_path = File.expand_path '~/.animotorc'
        config = if File.exist?(home_path)
          YAML.load(File.read(home_path))
        elsif File.exist?('/etc/.animotorc')
          YAML.load(File.read('/etc/.animotorc'))
        end
        if config
          @username ||= config['username']
          @password ||= config['password']
        else
          raise ArgumentError, "You must supply a username and password"
        end
      end
      @format = 'json'
      uri = URI.parse(API_ENDPOINT)
      @http = Net::HTTP.new uri.host, uri.port
      @http.use_ssl = true
    end
    
    def find klass, url, options = {}
      klass.load(find_request(klass, url, options))
    end
    
    def direct! manifest, options = {}
      DirectingJob.load(send_manifest(manifest, DirectingJob.endpoint, options))
    end
    
    def render! manifest, options = {}
      RenderingJob.load(send_manifest(manifest, RenderingJob.endpoint, options))
    end
    
    def direct_and_render! manifest, options = {}
      DirectingAndRenderingJob.load(send_manifest(manifest, DirectingAndRenderingJob.endpoint, options))
    end
    
    def reload resource, options = {}
      resource.reload(find_request(resource.class, resource.url, options))
    end
    
    private
    
    def find_request klass, url, options = {}
      request(:get, URI.parse(url).request_uri, nil, { "Accept" => content_type_of(klass) }, options)
    end
    
    def send_manifest manifest, url, options = {}
      request(:post, URI.parse(url).request_uri, manifest.to_json, { "Accept" => "application/#{format}", "Content-Type" => content_type_of(manifest) }, options)
    end
    
    def request method, uri, body, headers = {}, options = {}
      req = build_request method, uri, body, headers, options
      read_response @http.request(req)
    end
    
    def build_request method, uri, body, headers, options
      req = HTTP_METHOD_MAP[method].new uri
      req.body = body
      req.initialize_http_header headers
      req
    end
    
    def read_response response
      check_status response
      parse_response response
    end
    
    def check_status response
      raise(response.message) unless (200..299).include?(response.code.to_i)
    end
    
    def parse_response response
      JSON.parse(response.body)
    end
    
    def content_type_of klass_or_instance
      klass = klass_or_instance.is_a?(Class) ? klass_or_instance : klass_or_instance.class
      "#{BASE_CONTENT_TYPE}.#{klass.content_type}-v#{API_VERSION}+#{format}"
    end
    
  end
end