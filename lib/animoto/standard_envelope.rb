module Animoto
  module StandardEnvelope
    
    def self.included base
      base.class_eval {
        include Animoto::StandardEnvelope::InstanceMethods
        extend Animoto::StandardEnvelope::ClassMethods
      }
    end
    
    module InstanceMethods
      def unpack_standard_envelope body = {}
        self.class.unpack_standard_envelope body
      end
    end
    
    module ClassMethods
      protected
      def unpack_standard_envelope body = {}
        {
          :url => body['response']['payload'][payload_key]['links']['self'],
          :errors => body['response']['status']['errors'] || []
        }
      end
    end
  end
end