require 'curl'

module Animoto
  class HTTPEngine
    class CurlAdapter < Animoto::HTTPEngine
      
      def request method, url, body = nil, headers = {}, options = {}
        curl = build_curl method, url, body, headers, options
        perform curl, method, body
        check_response curl.response_code, curl.body_str
        curl.body_str
      end
      
      private
      
      def build_curl method, url, body, headers, options
        ::Curl::Easy.new(url) do |c|
          c.username = options[:username]
          c.password = options[:password]
          c.timeout = options[:timeout]
          c.post_body = body
          headers.each { |header, value| c.headers[header] = value }
        end
      end
      
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