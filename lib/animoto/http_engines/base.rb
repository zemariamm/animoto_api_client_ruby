module Animoto
  module HTTPEngines    
    extend Support::DynamicClassLoader
    
    dynamic_class_path File.expand_path(File.dirname(__FILE__))
    
    adapter 'Curl'
    adapter 'NetHTTP'
    adapter 'Patron'
    adapter 'RestClient'
    adapter 'Typhoeus'
        
    # @abstract Override {#request} to subclass.
    class Base
      
      # Make a request.
      #
      # @abstract
      # @param [Symbol] method the HTTP method to use, should be lower-case (that is, :get
      #   instead of :GET)
      # @param [String] url the URL to request
      # @param [String,nil] body the request body
      # @param [Hash{String=>String}] headers request headers to send; names will be sent as-is
      #   (for example, use keys like "Content-Type" and not :content_type)
      # @param [Hash{Symbol=>Object}] options
      # @option options [Integer] :timeout set a timeout
      # @option options [String] :username the authentication username
      # @option options [String] :password the authentication password
      # @return [String] the response body
      # @raise [AbstractMethodError] if called on the abstract class
      def request method, url, body = nil, headers = {}, options = {}
        raise AbstractMethodError
      end
    
      private
    
      # Checks the response and raises an error if the status isn't success.
      #
      # @param [Integer] code the HTTP status code
      # @param [String] body the HTTP response body
      # @return [void]
      # @raise [Animoto::Error] if the status isn't between 200 and 299
      def check_response code, body
        throw(:fail, [code,body]) unless (200..299).include?(code)
      end
    end
  end
end
