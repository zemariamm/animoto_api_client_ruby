module Animoto
  module Resources

    # @abstract Set {#endpoint} and maybe override {Support::StandardEnvelope::ClassMethods#unpack_standard_envelope} to subclass.
    class Base
      include Support::StandardEnvelope
    
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

      # Makes a new instance of this class from a deserialized response body. Note that
      # it assumes the hash you're passing is structured correctly and does no format checking
      # at all, so if the hash is not in the "standard envelope", this method will most likely
      # raise an error.
      #
      # @private
      # @param [Hash{String=>Object}] body the deserialized response body
      # @return [Resources::Base] an instance of this class
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
        #   storyboard1 = Animoto::Resources::Storyboard.new :url => "https://api.animoto.com/storyboards/1"
        #   storyboard2 = client.find! Animoto::Resources::Storyboard, "https://api.animoto.com/storyboards/1"
        #   storyboard1.equal?(storyboard2) # => true
        #
        # @param [Hash{String=>Object}] attributes a hash of attributes for this resource
        # @return [Resources::Base] either a new Resource instance, or an existing one with updated
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
        # @param [Resources::Base] instance the instance to register
        # @raise [ArgumentError] if the instance isn't of this class
        def register instance
          raise ArgumentError unless instance.is_a?(self)
          instances[instance.url] = instance
        end
      
        private

        # Returns (or vivifies) the identity map for this class.
        #
        # @return [Hash{String=>Resources::Base}] the identity map
        def instances
          @instances ||= {}
        end
      end
    
      attr_reader :url, :errors

      # Creates a new resource.
      #
      # @param [Hash{String=>Object}] attributes hash of attributes for this resource
      # @see #instantiate
      # @return [Resources::Base] the resource
      def initialize attributes = {}
        instantiate attributes
      end
    
      # Update this instance with new attributes from the response body.
      #
      # @private
      # @param [Hash{String=>Object}] body deserialized from a response body
      # @return [self] this instance, updated
      def load body = {}
        instantiate unpack_standard_envelope(body)
      end
    
      # Since resources can be created a number of different ways, this method does
      # the actual attribute setting for a resource, acting much like a public version
      # of #initialize.
      #
      # @private
      # @param [Hash{Symbol=>Object}] attributes hash of attributes for this resource
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
      # @param [Hash{String=>Object}] error the error "object" from a response body
      # @return [Animoto::Error] a Ruby error object
      def wrap_error error
        Animoto::Error.new error['message']
      end
    end
  end
end