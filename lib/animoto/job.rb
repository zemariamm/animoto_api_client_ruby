module Animoto
  class Job < Animoto::Resource
    
    def self.unpack_standard_envelope body
      super.merge(:state => body['response']['payload'][payload_key]['state'])
    end
        
    attr_reader :url, :state, :errors
    
    # Returns true if the state of this job is 'failed'.
    #
    # @return [Boolean] whether or not the job has failed.
    def failed?
      @state == 'failed'
    end
    
    # Returns true if the state of this job is 'completed'.
    #
    # @return [Boolean] whether or not the job is completed
    def completed?
      @state == 'completed'
    end
    
    # Returns true if the job is neither failed or completed.
    #
    # @return [Boolean] whether or not the job is still pending
    def pending?
      !failed? && !completed?
    end

    def instantiate attributes = {}
      @state  = attributes[:state]
      super
    end
    
  end
end