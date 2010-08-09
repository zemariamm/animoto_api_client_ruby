module Animoto
  class Job < Animoto::Resource
    
    def self.unpack_standard_envelope body
      super.merge(:state => body['payload'][payload_key]['state'])
    end
        
    attr_reader :url, :state, :errors
    
    def initialize options = {}
      @state = options[:state]
      @url = options[:url]
      @errors = (options[:errors] || []).collect { |e| wrap_error(e) }
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

    def reload body = {}
      @state  = body['payload'][payload_key]['state']
      @errors = (body['response']['status']['errors'] || []).collect { |e| wrap_error(e) }
      self
    end
    
    private
    
    def wrap_error error
      Animoto::Error.new error['message']
    end
  end
end