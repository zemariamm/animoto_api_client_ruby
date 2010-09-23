require 'patron'

module Animoto
  module HTTPEngines
    class PatronAdapter < Animoto::HTTPEngines::Base
      
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
        session.username = options[:username]
        session.password = options[:password]
        session
      end
    end
    
    adapter_map.merge! :patron => PatronAdapter
  end
end