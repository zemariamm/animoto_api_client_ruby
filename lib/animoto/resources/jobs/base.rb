module Animoto
  module Resources
    module Jobs

      # @abstract
      class Base < Animoto::Resources::Base
        
        # @return [Hash<Symbol,Object>]
        def self.unpack_standard_envelope body
          super.merge(:state => body['response']['payload'][payload_key]['state'])
        end
        
        # @return [String]
        def self.infer_content_type
          super + '_job'
        end
        
        # The URL for this job.
        # @return [String]
        attr_reader :url
        
        # The state of this job.
        # @return [String]
        attr_reader :state
        
        # Errors associated with this job.
        # @return [Array<Animoto::Error>]
        attr_reader :errors
    
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

        # @return [Jobs::Base]
        # @see Animoto::Resources::Base#instantiate
        def instantiate attributes = {}
          @state  = attributes[:state]
          super
        end
    
      end
    end
  end
end