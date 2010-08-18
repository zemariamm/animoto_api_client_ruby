require 'nokogiri'

module Animoto
  class ResponseParser
    class NokogiriAdapter < Animoto::ResponseParser
      
      @format = 'xml'

      def parse str
        xml = ::Nokogiri::XML(str)
        handle xml.root
      end
      
      def unparse obj, xml = nil
        xml ||= ::Nokogiri::XML::Document.new
        if obj.is_a?(Hash)
          obj.each do |key, value|
            if value.is_a?(Array)
              value.each do |elem|
                node = ::Nokogiri::XML::Node.new key, doc(xml)
                unparse(elem, node)
                xml << node
              end
            else
              node = ::Nokogiri::XML::Node.new(key, doc(xml))
              unparse(value, node)
              xml << node
            end
          end
        else
          xml << ::Nokogiri::XML::Text.new(obj.to_s, doc(xml))
        end
        xml.to_s
      end
      
      private
      
      def doc document_or_node
        document_or_node.is_a?(::Nokogiri::XML::Document) ? document_or_node : document_or_node.document
      end
      
      def handle node, hash = {}
        if node.children.size == 1 && node.children.first.text?
          if hash.has_key?(node.name)
            hash.merge! node.name => (Array(hash[node.name]) << convert(node.children.first.text))
          else
            hash.merge! node.name => convert(node.children.first.text)
          end
        else
          hash.merge! node.name => node.children.inject({}) { |h,n| handle(n, h) }
        end
        hash
      end
      
      def convert text
        case text
        when /^[-+]?[1-9][0-9]*$/
          text.to_i
        when /^[-+]?(?:[1-9][0-9]*)\.[0-9]+$/
          text.to_f
        else
          text
        end
      end
    end
    
    adapter_map.merge! :nokogiri => NokogiriAdapter
  end
end