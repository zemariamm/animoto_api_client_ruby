module Animoto
  module Resources
    module Jobs
      class Directing < Animoto::Resources::Jobs::Base
    
        endpoint '/jobs/directing'

        # @return [Hash{Symbol=>Object}]
        # @see Animoto::Support::StandardEnvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body
          super.merge(:storyboard_url => unpack_links(body)['storyboard'])
        end
    
        # The Storyboard created by this job.
        # @return [Resources::Storyboard]
        attr_reader :storyboard
        
        # The URL for this storyboard resource created by this job.
        # @return [String]
        attr_reader :storyboard_url

        # @return [Jobs::Directing]
        # @see Animoto::Jobs::Base#instantiate
        def instantiate attributes = {}
          @storyboard_url = attributes[:storyboard_url]
          @storyboard = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
          super
        end
      end
    end
  end
end