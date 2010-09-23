module Animoto
  module Support
    class XMLSchemaReader

      TYPE_CONVERSION_MAP = {
        'xs:boolean'            => Proc.new { |val| eval(val) },
        'xs:base64Binary'       => Proc.new { |val| val.to_s },
        'xs:hexBinary'          => Proc.new { |val| val.to_s },
        'xs:anyURI'             => Proc.new { |val| val.to_s },
        'xs:language'           => Proc.new { |val| val.to_s },
        'xs:normalizedString'   => Proc.new { |val| val.to_s },
        'xs:string'             => Proc.new { |val| val.to_s },
        'xs:token'              => Proc.new { |val| val.to_s },
        'xs:byte'               => Proc.new { |val| val.to_i },
        'xs:decimal'            => Proc.new { |val| val.to_i },
        'xs:double'             => Proc.new { |val| val.to_f },
        'xs:float'              => Proc.new { |val| val.to_f },
        'xs:int'                => Proc.new { |val| val.to_i },
        'xs:integer'            => Proc.new { |val| val.to_i },
        'xs:long'               => Proc.new { |val| val.to_i },
        'xs:negativeInteger'    => Proc.new { |val| val.to_i },
        'xs:nonNegativeInteger' => Proc.new { |val| val.to_i },
        'xs:nonPositiveInteger' => Proc.new { |val| val.to_i },
        'xs:positiveInteger'    => Proc.new { |val| val.to_i },
        'xs:short'              => Proc.new { |val| val.to_i },
        'xs:unsignedByte'       => Proc.new { |val| val.to_i },
        'xs:unsignedInt'        => Proc.new { |val| val.to_i },
        'xs:unsignedLong'       => Proc.new { |val| val.to_i },
        'xs:unsignedShort'      => Proc.new { |val| val.to_i },
        'xs:date'               => Proc.new { |val| Date.parse(val) },
        'xs:dateTime'           => Proc.new { |val| DateTime.parse(val) },
        'xs:duration'           => Proc.new { |val| val.to_s },
        'xs:gDay'               => Proc.new { |val| val.to_s },
        'xs:gMonth'             => Proc.new { |val| val.to_s },
        'xs:gMonthDay'          => Proc.new { |val| val.to_s },
        'xs:gYear'              => Proc.new { |val| val.to_s },
        'xs:time'               => Proc.new { |val| val.to_s }
      }

      def initialize parser, schema
        @parser = parser
        @schema = parser.new_document(schema)
      end

      def convert node
        content = parser.read_content(node)
        if converter = TYPE_CONVERSION_MAP[type_of(node)]
          converter.call(content)
        else
          content
        end
      end

      def type_of node
        path = parser.path_to(node)
        xpath = './' + paths.collect { |path| %Q{xs:element[@name="#{path}"][1]} }.join('/descendant::') + '/@type'
        if attr_node = parser.find_at_xpath(schema_root, xpath)
          parser.read_attribute_node_value(attr_node)
        else
          'xs:string'
        end
      end

      private

      def find_node_type_from_path node, *paths
        if type = 
      end

      def schema_root
        parser.root_of(@schema)
      end

    end
  end
end