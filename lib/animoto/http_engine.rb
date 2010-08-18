module Animoto
  class HTTPEngine
    extend DynamicClassLoader
    
    # Make a request.
    #
    # @param [Symbol] method the HTTP method to use, should be lower-case (that is, :get
    #   instead of :GET)
    # @param [String] url the URL to request
    # @param [String,nil] body the request body
    # @param [Hash<String,String>] headers request headers to send; names will be sent as-is
    #   (for example, use keys like "Content-Type" and not :content_type)
    # @param [Hash<Symbol,Object>] options
    #   @option options :timeout set a timeout
    #   @option options :username the authentication username
    #   @option options :password the authentication password
    # @return [String] the response body
    # @raise [NotImplementedError] if called on the abstract class
    def request method, url, body = nil, headers = {}, options = {}
      raise NotImplementedError
    end
    
    private
    
    # Checks the response and raises an error if the status isn't success.
    #
    # @param [Fixnum] code the HTTP status code
    # @param [String] body the HTTP response body
    # @raise [Animoto::Error] if the status isn't between 200 and 299
    def check_response code, body
      throw(:fail, body) unless (200..299).include?(code)
    end
  end
end