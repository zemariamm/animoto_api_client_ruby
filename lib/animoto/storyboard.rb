module Animoto
  class Storyboard < Animoto::Resource
    
    content_type 'storyboard'

    attr_reader :url
    
    def initialize options = {}
      @url = options[:url]
    end
    
  end
end