module Animoto
  class Resource
    include ContentType
    include StandardEnvelope
    
    # @overload endpoint(path)
    #   Sets the endpoint for this class. This is the URL where all requests related
    #   to this service will go.
    #
    #   @param [String] path the path to set
    #   @return [String] the endpoint
    #
    # @overload endpoint()
    #   Returns the endpoint for this class.
    #
    #   @return [String] the endpoint
    def self.endpoint path = nil
      @endpoint = path if path
      @endpoint
    end

    # Returns the endpoint for this class.
    # 
    # @return [String] the endpoint
    def endpoint
      self.class.endpoint
    end

    # @overload payload_key(key)
    #   Sets the payload key for this class. When building an instance of this class from
    #   a response body, the payload key determines which object in the response payload
    #   holds the attributes for the instance.
    #
    #   @param [String] key the key to set
    #   @return [String] the key
    #   
    # @overload payload_key()
    #   Returns the payload key for this class.
    #
    #   @return [String] the key
    def self.payload_key key = nil
      @payload_key = key if key
      @payload_key || infer_content_type
    end

    # Returns the payload key for this class.
    #
    # @return [String] the key
    def payload_key
      self.class.payload_key
    end
    
    # Makes a new instance of this class from a deserialized response body. Note that
    # it assumes the hash you're passing is structured correctly and does no format checking
    # at all, so if the hash is not in the "standard envelope", this method will most likely
    # raise an error.
    #
    # @private
    # @param [Hash] body the deserialized response body
    # @return [Resource] an instance of this class
    def self.load body
      new unpack_standard_envelope(body)
    end
  
    class << self
      
      # If an instance is instantiated with the same unique identifier (i.e. URL) as another,
      # instead of creating a brand new object, will instead update and return the existing
      # object. This way there should only be one object representing any one resource.
      #
      # @example
      #   client = Animoto::Client.new
      #   storyboard1 = Animoto::Storyboard.new :url => "https://api.animoto.com/storyboards/1"
      #   storyboard2 = client.find! Animoto::Storyboard, "https://api.animoto.com/storyboards/1"
      #   storyboard1.equal?(storyboard2) # => true
      #
      # @param [Hash] attributes a hash of attributes for this resource
      # @return [Resource] either a new Resource instance, or an existing one with updated
      #   attributes
      alias_method :original_new, :new
      def new attributes = {}
        if attributes[:url] && instances[attributes[:url]]
          instances[attributes[:url]].instantiate attributes
        else
          original_new attributes
        end
      end

      # Registers an instance in the identity map so that subsequent finds or instantiations
      # of this resource with the same URL will return the same object.
      #
      # @private
      # @param [Resource] instance the instance to register
      # @raise [ArgumentError] if the instance isn't of this class
      def register instance
        raise ArgumentError unless instance.is_a?(self)
        instances[instance.url] = instance
      end
      
      private

      # Returns (or vivifies) the identity map for this class.
      #
      # @return [Hash<String,Resource>] the identity map
      def instances
        @instances ||= {}
      end
    end
    
    attr_reader :url, :errors

    def initialize attributes = {}
      instantiate attributes
    end
    
    # Update this instance with new attributes from the response body.
    #
    # @private
    # @param [Hash] body deserialized from a response body
    # @return [self] this instance, updated
    def load body = {}
      instantiate unpack_standard_envelope(body)
    end
    
    # Since Resources can be created a number of different ways, this method does
    # the actual attribute setting for a Resource, acting much like a public version
    # of #initialize.
    #
    # @private
    # @param [Hash] attributes hash of attributes for this resource
    # @return [self] this instance
    def instantiate attributes = {}
      @errors = (attributes[:errors] || []).collect { |e| wrap_error e  }      
      @url    = attributes[:url]
      self.class.register(self) if @url
      self
    end
    
    private 
    
    # Turns an error from a response body into a Ruby object.
    #
    # @param [Hash] error the error "object" from a response body
    # @return [Error] a Ruby error object
    def wrap_error error
      Animoto::Error.new error['message']
    end
  end
end