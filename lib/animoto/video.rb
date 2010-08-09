module Animoto
  class Video < Animoto::Resource
    
    attr_reader :url
    
    def initialize options = {}
      @url = options[:url]
    end
    
  end
end