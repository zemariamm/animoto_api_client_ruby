require 'curl'

module Animoto
  module HTTPEngines
    class CurlAdapter < Animoto::HTTPEngines::Base
      
      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        curl = build_curl method, url, body, headers, options
        perform curl, method, body
        check_response curl.response_code, curl.body_str
        curl.body_str
      end
      
      private
      
      # Creates a Curl::Easy object with the headers, options, body, etc. set.
      #
      # @param [Symbol] method the HTTP method
      # @param [String] url the URL to request
      # @param [String,nil] body the request body
      # @param [Hash<String,String>] headers hash of HTTP request headers
      # @return [Curl::Easy] the Easy instance
      def build_curl method, url, body, headers, options
        ::Curl::Easy.new(url) do |c|
          c.username = options[:username]
          c.password = options[:password]
          c.timeout = options[:timeout]
          c.post_body = body
          headers.each { |header, value| c.headers[header] = value }
        end
      end
      
      # Performs the request.
      #
      # @param [Curl::Easy] curl the Easy object with the request parameters
      # @param [Symbol] method the HTTP method to use
      # @param [String] body the HTTP request body
      def perform curl, method, body
        case method
        when :get
          curl.http_get
        when :post
          curl.http_post(body)
        end
      end
    end
    
    adapter_map.merge! :curl => CurlAdapter
  end
end