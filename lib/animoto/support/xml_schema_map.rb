require 'open-uri'

module Animoto
  module Support
    class XMLSchemaMap

      attr_accessor :parser

      def initialize parser
        @parser = parser
        @map    = {}
      end
    
      def [] document
        if schema = schema_location(document)
          if schema_document = @map[schema]
            schema_document
          else
            xsd_file     = open(schema)
            xsd_document = parser.new_document(xsd_file.read)
            @map[schema] = xsd_document
            xsd_document
          end
        end
      end

      private

      def schema_location document
        if location = parser.read_attribute(parser.root_node(document), 'xsi:schemaLocation')
          location.gsub(/\s+/, '/')
        end
      end
    end
  end
end