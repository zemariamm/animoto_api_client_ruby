module Animoto
  module Visual
    
    # Setter for spotlighting, which instructs the director to give special attention
    # to this visual when directing.
    #
    # @param [Boolean] bool true if this visual should receive special attention
    def spotlit= bool
      @spotlit = bool
    end
    
    # Returns true if this visual is spotlit.
    #
    # @return [Boolean] whether or not this visual is spotlit
    def spotlit?
      @spotlit
    end

    # Returns a representation of this Visual as a Hash
    #
    # @return [Hash] this Visual as a Hash
    def to_hash
      hash = super rescue {}
      hash['spotlit'] = spotlit? unless @spotlit.nil?
      hash['type'] = self.class.name.split('::').last.gsub(/(^)?([A-Z])/) { "#{'_' unless $1}#{$2.downcase}" }
      hash
    end
    
  end
end