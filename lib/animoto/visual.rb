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
      hash['type'] = self.class.name.split('::').last.gsub(/(^)?([A-Z])/) { "#{'_' unless $1}#{$2.downcase}" }
      hash
    end
    
  end
end