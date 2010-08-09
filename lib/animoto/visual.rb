module Animoto
  module Visual
    
    def spotlit= bool
      @spotlit = bool
    end
    
    def spotlit?
      @spotlit
    end
    
    def to_hash
      hash = super rescue {}
      hash['spotlit'] = spotlit? unless @spotlit.nil?
      hash
    end
    
  end
end