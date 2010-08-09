module Animoto
  class Asset
    
    attr_accessor :source_url
    
    def initialize source_url, options = {}
      @source_url = source_url
    end
    
    def to_hash
      { 'source_url' => @source_url }
    end
    
  end
end