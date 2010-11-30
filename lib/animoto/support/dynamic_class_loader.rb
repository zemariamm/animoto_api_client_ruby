module Animoto
  module Support
    module DynamicClassLoader

      def [] name
        if klass = adapter_map[normalize_const_name(name)]
          const_get(klass)
        else
          raise NameError, "uninitialized constant #{self.name}::#{name}"
        end
      end

      private

      def dynamic_class_path path = nil
        @dynamic_class_path = path if path
        @dynamic_class_path
      end
    
      def adapter_map
        @adapter_map ||= {}
      end
    
      def adapter name
        klass_name = :"#{name}Adapter"
        klass_file = klass_name.to_s.underscore
        self.autoload klass_name, "#{dynamic_class_path}/#{klass_file}"
        adapter_map[normalize_const_name(klass_file)] = klass_name
      end
    
      def const_missing name
        if klass_name = adapter_map[normalize_const_name(name)]
          klass = const_get(klass_name)
          const_set name, klass
          klass
        end
      rescue NameError
        super
      end

      def normalize_const_name name
        name.to_s.downcase[/^([\w_]+?)(?:_adapter)?$/,1].gsub(/[^a-z]/,'')
      end

    end
  end 
end