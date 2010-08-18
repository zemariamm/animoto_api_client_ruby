require 'rexml/document'

module Animoto
  class ResponseParser
    class REXMLAdapter < Animoto::ResponseParser
      
      @format = 'xml'
      
      def parse str
        xml = ::REXML::Document.new str
        handle xml.root
      end
      
      def unparse obj, xml = nil
        xml ||= ::REXML::Document.new
        if obj.is_a?(Hash)
          obj.each do |key, value|
            if value.is_a?(Array)
              value.each do |elem|
                node = ::REXML::Element.new key, xml
                unparse(elem, node)
              end
            else
              node = ::REXML::Element.new key, xml
              unparse(value, node)
            end
          end
        else
          xml << ::REXML::Text.new(obj.to_s, xml)
        end
        xml.to_s
      end

      private
      
      def handle node, hash = {}
        if node.children.size == 1 && node.children.first.node_type == :text
          if hash.has_key?(node.name)
            hash.merge! node.name => (Array(hash[node.name]) << convert(node.children.first.value))
          else
            hash.merge! node.name => convert(node.children.first.value)
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
    
    adapter_map.merge! :rexml => REXMLAdapter
  end
end