require 'net/http'
require 'net/https'

module Animoto
  class HTTPEngine
    class NetHTTP < Animoto::HTTPEngine
      
      HTTP_METHOD_MAP   = {
        :get  => Net::HTTP::Get,
        :post => Net::HTTP::Post
      }
      
      def request method, url, body = nil, headers = {}, options = {}
        uri = URI.parse(url)
        http = build_http uri
        req = build_request method, uri, body, headers, options
        response = http.request req
        check_response response
        response.body
      end
      
      private

      # Makes a new HTTP object.
      #
      # @param [URI] uri a URI object of the request URL
      # @return [Net::HTTP] the HTTP object
      def build_http uri
        http = Net::HTTP.new uri.host, uri.port
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
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
      def build_request method, uri, body, header, options
        req = HTTP_METHOD_MAP[method].new uri.path
        req.body = body
        req.initialize_http_header headers
        req.basic_auth options[:username], options[:password]
        req
      end
      
      # Checks the status of the response to make sure it's successful.
      #
      # @param [Net::HTTPResponse] response the response object
      # @return [nil]
      # @raise [Error,RuntimeError] if the response code isn't in the 200 range
      def check_response response
        raise_from_response_body(response.body_str) unless (200..299).include?(response.code.to_i)
      end
      
    end
  end
end