module Animoto
  class Job < Animoto::Resource
    
    def self.payload_key key = nil
      @payload_key = key if key
      @payload_key || infer_content_type
    end
    
    def payload_key
      self.class.payload_key
    end
    
    attr_reader :url, :state, :errors, :http_status_code
    
    def initialize body = {}
      @errors = (body['response']['status']['errors'] || []).collect { |error| wrap_error(error) }
      @http_status_code = body['response']['status']['code']
      @state  = body['payload'][payload_key]['state']
      @url    = body['payload'][payload_key]['links']['self']
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