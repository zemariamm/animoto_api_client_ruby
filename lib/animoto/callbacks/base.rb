module Animoto
  module Callbacks

    # @abstract
    class Base
      include Support::StandardEnvelope

      # @return [String]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#payload_key
      def self.payload_key
        super + '_callback'
      end
      
      # @return [Hash<Symbol,Object>]
      # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
      def self.unpack_standard_envelope body = {}
        super.merge({ :state => body['response']['payload'][payload_key]['state'] })
      end

      # The state of the job when it completed.
      # @return [String]
      attr_reader :state
      
      # Errors for the job.
      # @return [Array<Animoto::Error>]
      attr_reader :errors
      
      # The url for this job.
      # @return [String]
      attr_reader :url

      # Creates a new Callback.
      #
      # @param [String] body the request body of the HTTP callback
      # @return [Callbacks::Base] the Callback
      def initialize body
        params = unpack_standard_envelope(body)
        @state  = params[:state]
        @errors = params[:errors].collect { |e| Animoto::Error.new(e['message']) }
        @url    = params[:url]
      end
      
    end
  end
end