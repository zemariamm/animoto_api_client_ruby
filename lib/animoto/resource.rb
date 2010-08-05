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
      @content_type
    end
    
    def content_type
      self.class.content_type
    end
    
    def self.load body, headers
      
    end
    
    def initialize *args
      
    end

  end
end