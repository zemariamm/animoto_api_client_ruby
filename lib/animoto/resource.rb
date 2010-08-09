module Animoto
  class Resource
    
    def self.endpoint path = nil
      @endpoint = path if path
      @endpoint
    end
    
    def endpoint
      self.class.endpoint
    end
    
    def self.content_type type = nil
      @content_type = type if type
      @content_type ||= infer_content_type
    end
    
    def self.infer_content_type
      name.split('::').last.gsub(/(^)?([A-Z])/) { "#{'_' unless $1}#{$2.downcase}" }
    end
    private_class_method :infer_content_type
    
    def content_type
      self.class.content_type
    end
    
    def self.payload_key key = nil
      @payload_key = key if key
      @payload_key || infer_content_type
    end
    
    def payload_key
      self.class.payload_key
    end
    
    def self.load body
      new(unpack_standard_envelope(body))
    end
    
    def self.unpack_standard_envelope body
      {
        :http_status_code => body['response']['status']['code'],
        :url => body['payload'][payload_key]['links']['self'],
        :errors => body['response']['status']['errors'] || []
      }
    end
    private_class_method :unpack_standard_envelope

    def initialize *args
      
    end

  end
end