module Animoto
  class ResponseParser
    class JSON < Animoto::ResponseParser
      
      @format = 'json'
      
      def parse body
        ::JSON.parse body
      end
      
      def unparse hash
        ::JSON.unparse hash
      end
      
    end
  end
end