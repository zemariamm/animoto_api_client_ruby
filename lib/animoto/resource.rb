module Animoto
  class Resource
    include ContentType
    include StandardEnvelope
    
    def self.endpoint path = nil
      @endpoint = path if path
      @endpoint
    end
  
    def endpoint
      self.class.endpoint
    end
        
    def self.payload_key key = nil
      @payload_key = key if key
      @payload_key || infer_content_type
    end

    def payload_key
      self.class.payload_key
    end
    
    def self.load body
      new unpack_standard_envelope(body)
    end
  
    class << self
      alias_method :original_new, :new
      def new attributes = {}
        if attributes[:url] && instances[attributes[:url]]
          instances[attributes[:url]].instantiate attributes
        else
          original_new attributes
        end
      end

      def register instance
        raise ArgumentError unless instance.is_a?(self)
        instances[instance.url] = instance
      end
      
      private

      def instances
        @instances ||= {}
      end
    end
    
    attr_reader :url, :errors

    def initialize attributes = {}
      instantiate attributes
    end
    
    def load body = {}
      instantiate unpack_standard_envelope(body)
    end
    
    def instantiate attributes = {}
      @errors = (attributes[:errors] || []).collect { |e| wrap_error e  }      
      @url    = attributes[:url]
      self.class.register(self) if @url
      self
    end
    
    private 
    
    def wrap_error error
      Animoto::Error.new error['message']
    end
  end
end