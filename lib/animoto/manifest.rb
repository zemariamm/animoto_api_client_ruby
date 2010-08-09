module Animoto
  class Manifest
    include ContentType
    
    def to_hash
      {}
    end
    
    def to_json
      self.to_hash.to_json
    end
    
  end
end