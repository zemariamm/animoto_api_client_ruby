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
      
      def self.find_class_for envelope
        if payload_key = ((envelope['response'] || {})['payload'] || {}).keys.first
          klass_name = payload_key.camelize
          if /(?:Job|Callback)$/ === klass_name
            Animoto::Jobs::const_get(klass_name) if Animoto::Jobs::const_defined?(klass_name)
          else
            Animoto::Resources::const_get(klass_name) if Animoto::Resources::const_defined?(klass_name)
          end
        end
      rescue NameError
        nil
      end
    
      module InstanceMethods
        # Calls the class-level unpack_standard_envelope method.
        # @return [Hash<Symbol,Object>]
        # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
        def unpack_standard_envelope body
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

        # Extracts the base payload element from the envelope.
        #
        # @param [Hash<String,String>] body the response body
        # @return [Hash<String,String>] the base payload at $.response.payload
        def unpack_base_payload body
          (body['response'] || {})['payload'] || {}
        end
        
        # Extracts the base status element from the envelope.
        #
        # @param [Hash<String,String>] body the response body
        # @return [Hash<String,String>] the status element at $.response.status
        def unpack_status body
          (body['response'] || {})['status'] || {}
        end

        # Returns the payload, which is the part of the response classes will find the most
        # interesting.
        #
        # @param [Hash<String,String>] body the response body
        # @return [Hash<String,String>] the payload at $.response.payload[${payload_key}]
        def unpack_payload body
          unpack_base_payload(body)[payload_key] || {}
        end
        
        # Returns the links element of the payload, or an empty hash if it doesn't exist.
        # 
        # @param [Hash<String,String>] body the response body
        # @return [Hash<String,String>] the links at $.response.payload[${payload_key}].links
        def unpack_links body
          unpack_payload(body)['links'] || {}
        end

        # Extracts common elements from the 'standard envelope' and returns them in a
        # easier-to-work-with hash.
        #
        # @param [Hash<String,Object>] body the body, structured in the 'standard envelope'
        # @return [Hash<Symbol,Object>] the nicer hash
        def unpack_standard_envelope body
          {
            :url    => unpack_links(body)['self'],
            :errors => unpack_status(body)['errors'] || []
          }
        end        
      end
    end
  end
end