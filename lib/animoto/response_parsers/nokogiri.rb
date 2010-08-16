require 'nokogiri'

module Animoto
  class ResponseParser
    class Nokogiri < Animoto::ResponseParser
      
      def parse body
        xml = Nokogiri::XML(body)
        handle(xml.root)
      end
      
      def unparse hash
        
      end
      
      private
      
      def handle tag
        case tag
        when Nokogiri::XML::Text
          tag.text
        when Nokogiri::XML::Node
          { tag.name.to_sym => handle(tag.children) }
        when Nokogiri::XML::NodeSet
          
        else
          
        end
      end
    end
  end
end