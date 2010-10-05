module Animoto
  module Support
    module StandardEnvelope
    
      # When included into a class, also extends ClassMethods, inludes InstanceMethods, and
      # includes Support::ContentType
      def self.included base
        base.class_eval {
          include Animoto::Support::StandardEnvelope::InstanceMethods
          extend Animoto::Support::StandardEnvelope::ClassMethods
          include Animoto::Support::ContentType
        }
      end
    
      module InstanceMethods
        # Calls the class-level unpack_standard_envelope method.
        # @return [Hash<Symbol,Object>]
        # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
        def unpack_standard_envelope body = {}
          self.class.unpack_standard_envelope body
        end

        # Returns the payload key for this class, i.e. the name of the key inside the 'payload'
        # object of the standard envelope where this resource's information is.
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

        # Extracts common elements from the 'standard envelope' and returns them in a
        # easier-to-work-with hash.
        #
        # @param [Hash<String,Object>] body the body, structured in the 'standard envelope'
        # @return [Hash<Symbol,Object>] the nicer hash
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