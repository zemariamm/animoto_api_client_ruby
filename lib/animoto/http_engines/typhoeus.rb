require 'typhoeus'

module Animoto
  class HTTPEngine
    class Typhoeus < Animoto::HTTPEngine
      
      def request method, url, body = nil, headers = {}, options = {}
        response = ::Typhoeus::Request.run(url, {
          :method => method,
          :body => body,
          :headers => headers,
          :timeout => options[:timeout],
          :username => options[:username],
          :password => options[:password]
        })
        check_response response.code, response.body
        response.body
      end
      
    end
  end
end