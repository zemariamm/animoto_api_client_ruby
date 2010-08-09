module Animoto
  module ContentType
    
    def self.included base
      base.class_eval {
        include Animoto::ContentType::InstanceMethods
        extend Animoto::ContentType::ClassMethods
      }
    end
    
    module InstanceMethods
      def content_type
        self.class.content_type
      end
    end
    
    module ClassMethods
      def content_type type = nil
        @content_type = type if type
        @content_type || infer_content_type
      end
      
      private
      
      def infer_content_type
        name.split('::').last.gsub(/(^)?([A-Z])/) { "#{'_' unless $1}#{$2.downcase}" }
      end      
    end
  end
end