require 'patron'

module Animoto
  module HTTPEngines
    class PatronAdapter < Animoto::HTTPEngines::Base
      
      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        session = build_session options
        response = session.request method, url, headers, :data => body
        check_response response.status, response.body
        response.body
      end
      
      private
      
      # Builds the Session object.
      #
      # @param [Hash{Symbol=>Object}] options options for the Session
      # @return [Patron::Session] the Session object
      def build_session options
        session = ::Patron::Session.new
        session.timeout = options[:timeout]
        session.username = options[:username]
        session.password = options[:password]
        session
      end
    end    
  end
end