module Animoto
  class HTTPEngine

    # If a reference is made to a class under this one that hasn't been initialized yet,
    # this will attempt to require a file with that class' name (underscored). If one is
    # found, and the file defines the class requested, will return that class object.
    #
    # @param [Symbol] const the uninitialized class' name
    # @return [Class] the class found
    # @raise [NameError] if the file defining the class isn't found, or if the file required
    #   doesn't define the class.
    def self.const_missing const
      engine_name = const.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      file_name = File.dirname(__FILE__) + "/http_engines/#{engine_name}.rb"
      if File.exist?(file_name)
        require file_name
        const_defined?(const) ? const_get(const) : super
      else
        super
      end
    end
    
    def self.[] engine
      const_get engine
    end
    
    attr_accessor :base_url
    
    def initialize base_url
      @base_url = base_url
    end
    
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
    
    def check_response code, body
      raise_from_response_body(body) unless (200..299).include?(code)
    end
    
    def raise_from_response_body body
      if body
        begin
          json = JSON.parse(body)
          errors = json['response']['status']['errors']
        rescue => e
          raise alt_message
        else
          raise Animoto::Error.new(errors.collect { |e| e['message'] }.join(', '))
        end
      else
        raise alt_message
      end      
    end
  end
end