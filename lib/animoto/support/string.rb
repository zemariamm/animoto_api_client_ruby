module Animoto
  module Support
    module String
      
      def camelize
        self.gsub(/(?:^|_)(.)/) { $1.upcase }
      end
      
      def underscore
        self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      end
      
    end
  end
end

String.__send__ :include, Animoto::Support::String