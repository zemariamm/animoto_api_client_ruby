module Animoto
  module Callbacks
    class Base
      include Support::StandardEnvelope

      def self.payload_key
        super + '_callback'
      end
      
      def self.unpack_standard_envelope body = {}
        super.merge({ :state => body['response']['payload'][payload_key]['state'] })
      end

      attr_reader :state, :errors, :url
      
      def initialize body
        params = unpack_standard_envelope(body)
        @state  = params[:state]
        @errors = params[:errors].collect { |e| Animoto::Error.new(e['message']) }
        @url    = params[:url]
      end
      
    end
  end
end