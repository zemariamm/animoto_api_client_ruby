module Animoto
  module Support
    module ContentType
    
      # When included, includes the InstanceMethods module and extends the
      # ClassMethods module.
      # @return [void]
      def self.included base
        base.class_eval {
          include Animoto::Support::ContentType::InstanceMethods
          extend Animoto::Support::ContentType::ClassMethods
        }
      end
    
      module InstanceMethods
        # Returns the content type for this class.
        #
        # @return [String] the content type
        def content_type
          self.class.content_type
        end
      end
    
      module ClassMethods
        # @overload content_type(type)
        #   Sets the content type for this class.
        #   @param [String] content_type the type
        #   @return [String] the content type
        # @overload content_type()
        #   Returns the content type for this class.
        #   @return [String] the content type
        def content_type type = nil
          @content_type = type if type
          @content_type || infer_content_type
        end
      
        private
      
        # If no content type is explicitly set, this will infer the name of the content
        # type from the class name by lowercasing and underscoring the base name of the
        # class. For example, Animoto::DirectingJob becomes "directing_job".
        #
        # @return [String] the inferred content type
        def infer_content_type
          name.split('::').last.gsub(/(^)?([A-Z])/) { "#{'_' unless $1}#{$2.downcase}" }
        end      
      end
    end
  end
end