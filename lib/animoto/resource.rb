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
    
    def self.load payload
      new
    end
    
    def initialize *args
      
    end

  end
end