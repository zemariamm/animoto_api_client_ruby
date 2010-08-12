require 'patron'

module Animoto
  class HTTPEngine
    class Patron < Animoto::HTTPEngine
      
      def request method, url, body = nil, headers = {}, options = {}
        session = build_session options
        response = session.request method, url, headers, :data => body
        check_response response.status, response.body
        response.body
      end
      
      private
      
      def build_session options
        session = ::Patron::Session.new
        session.timeout = options[:timeout]
      end
    end
  end
end