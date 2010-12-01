module Animoto
  module Support
    module String
      
      # Transforms this string from underscore-form to camel case. Capitalizes
      # the first letter.
      #
      # @example
      #   "this_is_a_underscored_string" # => "ThisIsAUnderscoredString"
      #
      # @return [String] the camel case form of this string
      def camelize
        self.gsub(/(?:^|_)(.)/) { $1.upcase }
      end
      
      # Transforms this string from camel case to underscore-form. Downcases the
      # entire string.
      #
      # @example
      #   "ThisIsACamelCasedString" # => "this_is_a_camel_cased_string"
      #
      # @return [String] the underscored form of this string
      def underscore
        self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      end
      
    end
  end
end

String.__send__ :include, Animoto::Support::String