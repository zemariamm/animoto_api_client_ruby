module Animoto
  module Support
    module Hash
      
      def only *keys
        self.delete_if { |k,v| !keys.include?(k) }
      end
      
      def except *keys
        self.delete_if { |k,v| keys.include?(v) }
      end
      
    end
  end
end

Hash.__send__ :include, Animoto::Support::Hash