$:.unshift File.dirname(__FILE__)
require 'resource'
require 'asset'
require 'project'
require 'storyboard'
require 'video'
require 'job'
require 'directing_and_rendering_job'
require 'directing_job'
require 'rendering_job'

module Animoto
  class Client
    API_ENDPOINT      = "http://api.animoto.com/"
    API_VERSION       = 2
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    
    attr_accessor :username, :password
    attr_reader   :response_format
    
    def initialize *args
      
    end
    
    def response_format= format
      
    end
    
    def find klass, id
      
    end
    
    def create instance
      
    end
    
    def destroy instance
      
    end
    
    def direct! project, options = {}
      
    end
    
    def render! storyboard, options = {}
      
    end
    
    private
    
    def request method, url, options = {}
      
    end
  end
end