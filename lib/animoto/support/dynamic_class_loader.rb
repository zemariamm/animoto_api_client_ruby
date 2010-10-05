module Animoto
  module Support

    # Sets the search path where classes to be dynamically loaded can be found.
    # This method is meant to be used in the following manner:
    #   class Thing
    #     extend Animoto::Support::DynamicClassLoader("some/search/path")
    #   end
    # Behind the scenes, this method sets a temporary instance variable on the
    # DynamicClassLoader module which will be used (and then removed) the next time
    # the module is extended into a class. Therefore, don't call this method if you
    # don't intend to immediately extend the DynamicClassLoader module into the class
    # that the search path given applies to, else strange behaviors could emerge.
    #
    # @param [String] search_path the path where classes to be dynamically loaded are located
    # @return [Module] the DynamicClassLoader module
    def self.DynamicClassLoader search_path
      self::DynamicClassLoader.instance_variable_set(:@carryover_search_path, search_path)
      self::DynamicClassLoader
    end

    # This module is a helper for families of "plugins" which rely on external libraries.
    # It loads classes (and therefore their dependencies) on demand, obviating the need
    # to require every possible plugin dependency all the time or the need for the end-user
    # to explicitly require which certain plugin they want to use or know anything about the
    # specific directory structure where plugins are located.
    #
    # A class gets dynamically loaded in one of two ways: either a const_missing hook, or by
    # symbol-reference. Both methods interpolate the name of the file to load based on
    # their inputs.
    #
    # Referencing a class name under a module that is extended by the DynamicClassLoader will
    # search in the pre-set search path for a file matching the underscored version of the
    # class' name. For example, assuming the Thing module is extended with DynamicClassLoader
    # and its search path is "~/.things/plugins", referencing Thing::KlassName will look for
    # a file called "klass_name.rb" in "~/.things/plugins", returning the class object if it's
    # found or raising an exception if it isn't.
    #
    # Using a symbol reference is a little trickier. When a symbol is given to the [] method,
    # the name will be transformed (explained later) and a file in the search path with the
    # transformed name will be loaded, or an exception will be raised if the file isn't found.
    #
    # Name transformations are handled by three methods: symbol_reference_prefix,
    # symbol_reference_transform, and symbol_reference_prefix. As their names suggest,
    # symbol_reference_prefix and symbol_reference_suffix add the strings returned to the front
    # or end of the symbol name. symbol_reference_transform takes the string version of the symbol
    # and applies an arbitrary transform on it.
    #
    # After the file matching the transformed name is found, the class itself still has to
    # get loaded. While it's easy enough to take a class name and produce an associated file name,
    # the same is not true in reverse (for example, "HTTPEngine" => "http_engine" is straightforward,
    # but there's not enough information to turn "http_engine" into "HTTPEngine" without enforcing
    # class-naming restrictions). To get around this, any class that could get dynamically loaded
    # should add itself to its containing module's adapter map, using a key that matches the class'
    # file name.
    module DynamicClassLoader
      
      # When this module is extended into a class, it will set the search path where
      # dynamically loaded classes can be found if it was set using the DynamicClassLoader
      # method (see above). If not search path is set beforehand, it defaults to '.'.
      #
      # @param [Class] base the class this module will be extended into
      # @return [void]
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
        load_missing_file_named "#{symbol_reference_prefix}#{symbol_reference_transform(engine.to_s)}#{symbol_reference_suffix}"
        adapter_map[engine]
      end

      private
      
      # When a class is loaded by symbol reference, the return value of this method
      # will be prepended to the symbol to form the file name. Defaults to a blank
      # string.
      #
      # @return [String] the prefix
      def symbol_reference_prefix
        ''
      end
      
      # When a class is loaded by symbol reference, the return value of this method
      # will replace the symbol that was passed in. Defaults to return the symbol
      # unchanged.
      # Note, the word 'symbol' is used, but in reality it's a String and won't need
      # typecasting.
      #
      # @param [String] name the symbol referencing the class to load
      # @return [String] the transformed symbol
      def symbol_reference_transform name
        name
      end
      
      # When a class is loaded by symbol reference, the return value of this method
      # will be appended to the symbol to form the file name. Defaults to '_adapter'.
      #
      # @return [String] the suffix
      def symbol_reference_suffix
        '_adapter'
      end
      
      # Requires the file in the search path with the given name (minus trailing '.rb').
      #
      # @param [String] name the name of the file
      # @return [void]
      # @raise [NameError] if the file isn't found
      def load_missing_file_named name
        require "#{search_path}/#{name}.rb"
      rescue LoadError
        raise NameError, "Couldn't locate adapter named \"#{name}\""
      end
      
      # Returns the path where dynamically loaded files can be found. Defaults to '.' or
      # whatever was declared as the search path when this module was extended. The path
      # should not end with a trailing slash.
      #
      # @return [String] the path
      def search_path
        @dynamic_class_loader_search_path
      end

      # Returns a Hash mapping the symbolic names for adapters to their classes.
      #
      # @return [Hash<Symbol,Class>] the map of adapters
      def adapter_map
        @adapter_map ||= {}
      end

      # Turns a camel-cased class name into an underscored version. Will only affect the base name
      # of the class, so, for example, Animoto::DirectingAndRenderingJob becomes 'directing_and_rendering_job'
      #
      # @param [Class,String] klass a class or name of a class
      # @return [String] the underscored version of the name
      def underscore_class_name klass
        klass_name = klass.is_a?(Class) ? klass.name.split('::').last : klass
        klass_name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      end
    end
  end
end
