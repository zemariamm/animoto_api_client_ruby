module Animoto
  class Job < Animoto::Resource
    
    def self.unpack_standard_envelope payload
      super.merge(:state => payload['payload'][payload_key]['state'])
    end
        
    attr_reader :url, :state, :errors, :http_status_code
    
    def initialize options = {}
      @http_status_code = options[:http_status_code]
      @state = options[:state]
      @url = options[:url]
      @errors = options[:errors].collect { |e| wrap_error(e) }      
    end
    
    def failed?
      @state == 'failed'
    end
    
    def completed?
      @state == 'completed'
    end
    
    def pending?
      !failed? && !completed?
    end
    
    private
    
    def wrap_error error
      Animoto::Error.new error['message']
    end
  end
end