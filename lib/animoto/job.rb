module Animoto
  class Job < Animoto::Resource
    
    def self.unpack_standard_envelope body
      super.merge(:state => body['response']['payload'][payload_key]['state'])
    end
        
    attr_reader :url, :state, :errors
    
    def failed?
      @state == 'failed'
    end
    
    def completed?
      @state == 'completed'
    end
    
    def pending?
      !failed? && !completed?
    end

    def load attributes = {}
      @state  = attributes[:state]
      super
    end
    
  end
end