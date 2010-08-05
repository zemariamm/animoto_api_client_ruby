module Animoto
  class Resource
    
    def self.endpoint
      @endpoint
    end
    
    def self.endpoint= path
      @endpoint = path
    end
    
    def endpoint
      self.class.endpoint
    end
    
    def self.content_type
      @content_type
    end
    
    def self.content_type= type
      @content_type = type
    end
    
    def content_type
      self.class.content_type
    end
    
    def initialize *args
      
    end

    def to_request_body
      
    end
  end
end