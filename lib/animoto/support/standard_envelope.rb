module Animoto
  module Support
    module StandardEnvelope
    
      def self.included base
        base.class_eval {
          include Animoto::Support::StandardEnvelope::InstanceMethods
          extend Animoto::Support::StandardEnvelope::ClassMethods
          include Animoto::Support::ContentType
        }
      end
    
      module InstanceMethods
        def unpack_standard_envelope body = {}
          self.class.unpack_standard_envelope body
        end

        # Returns the payload key for this class.
        #
        # @return [String] the key
        def payload_key
          self.class.payload_key
        end
      end
    
      module ClassMethods
        # @overload payload_key(key)
        #   Sets the payload key for this class. When building an instance of this class from
        #   a response body, the payload key determines which object in the response payload
        #   holds the attributes for the instance.
        #
        #   @param [String] key the key to set
        #   @return [String] the key
        #   
        # @overload payload_key()
        #   Returns the payload key for this class.
        #
        #   @return [String] the key
        def payload_key key = nil
          @payload_key = key if key
          @payload_key || infer_content_type
        end

        protected        

        def unpack_standard_envelope body = {}
          {
            :url => body['response']['payload'][payload_key]['links']['self'],
            :errors => body['response']['status'] ? (body['response']['status']['errors'] || []) : []
          }
        end
      end
    end
  end
end