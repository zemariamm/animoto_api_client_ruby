module Animoto
  class Resource
    include ContentType
    
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
      new.load(unpack_standard_envelope(body))
    end
    
    def self.unpack_standard_envelope body
      {
        :url => body['response']['payload'][payload_key]['links']['self'],
        :errors => body['response']['status']['errors'] || []
      }
    end
    private_class_method :unpack_standard_envelope

    attr_reader :url, :errors

    def initialize attributes = {}
      load attributes
    end
    
    def update body = {}
      self
    end
    
    def load attributes = {}
      @url    = attributes[:url]
      @errors = (attributes[:errors] || []).collect { |e| wrap_error e  }
      self
    end
    
    private 
    
    def wrap_error error
      Animoto::Error.new error['message']
    end
  end
end