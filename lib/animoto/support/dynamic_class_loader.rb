module Animoto
  module Support

    def self.DynamicClassLoader search_path
      self::DynamicClassLoader.instance_variable_set(:@carryover_search_path, search_path)
      self::DynamicClassLoader
    end

    module DynamicClassLoader

      def self.extended base
        if instance_variable_defined?(:@carryover_search_path)
          base.instance_variable_set(:@dynamic_class_loader_search_path, @carryover_search_path)
          remove_instance_variable(:@carryover_search_path)
        else
          base.instance_variable_set(:@dynamic_class_loader_search_path, '.')
        end
      end
    
      # If a reference is made to a class under this one that hasn't been initialized yet,
      # this will attempt to require a file with that class' name (underscored). If one is
      # found, and the file defines the class requested, will return that class object.
      #
      # @param [Symbol] const the uninitialized class' name
      # @return [Class] the class found
      # @raise [NameError] if the file defining the class isn't found, or if the file required
      #   doesn't define the class.
      def const_missing const
        load_missing_file_named underscore_class_name(const.to_s)
        const_defined?(const) ? const_get(const) : super
      end

      # Returns the adapter class for the given symbol. If the file defining the class
      # hasn't been loaded, will try to load it.
      #
      # @param [Symbol] engine the symbolic name of the adapter
      # @return [Class] the class
      # @raise [NameError] if the class isn't found
      def [] engine
        load_missing_file_named "#{engine.to_s}_adapter"
        adapter_map[engine]      
      end

      private

      def dummy_binding
        @dummy_binding
      end
      
      def load_missing_file_named name
        require "#{base_search_path}/#{search_path}#{name}.rb"
      rescue LoadError
        raise NameError, "Couldn't locate adapter named \"#{name}\""
      end
      
      def base_search_path
        @dynamic_class_loader_search_path
      end

      # Returns the path relative to this file where dynamically loaded files can be found.
      # Defaults to an empty string. If the files are in a subdirectory, you should affix '/'
      # to the search path.
      #
      # @return [String] the path
      def search_path
        ''
      end
    
      # Returns a Hash mapping the symbolic names for adapters to their classes.
      #
      # @return [Hash] the map of adapters
      def adapter_map
        @adapter_map ||= {}
      end

      # Turns a camel-cased class name into an underscored version. Will only affect the base name
      # of the class, so, for example, Animoto::DirectingAndRenderingJob becomes 'directing_and_rendering_job'
      #
      # @param [Class, String] klass a class or name of a class
      # @return [String] the underscored version of the name
      def underscore_class_name klass
        klass_name = klass.is_a?(Class) ? klass.name.split('::').last : klass
        klass_name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      end
    end
  end
end
