require 'restclient'

module Animoto
  class HTTPEngine
    class RestClient < Animoto::HTTPEngine
      
      def request method, url, body = nil, headers = {}, options = {}
        response = ::RestClient::Request.execute({
          :method => method,
          :url => url,
          :headers => headers,
          :payload => body,
          :user => options[:username],
          :password => options[:password],
          :timeout => options[:timeout]
        })
        check_response response.code, response.body
        response.body
      end
      
    end
  end
end