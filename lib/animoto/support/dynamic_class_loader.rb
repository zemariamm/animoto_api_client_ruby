module Animoto
  module Support
    module DynamicClassLoader

      # Retrieves the adapter class that the name corresponds to. The name in case- and
      # punctuation-insensitive, meaning "SomeModule", "some_module", and "somemodule"
      # are all treated as the same.
      #
      # Note that classes defined as an #adapter for this module will be autoloaded upon
      # successful reference, so there's no need to ensure that the file defining the class
      # is already loaded when calling this method.
      #
      # @param [String] name the name of the module to access
      # @return [Class] the class
      # @raise [NameError] if the class doesn't exist.
      def [] name
        if klass = adapter_map[normalize_const_name(name)]
          const_get(klass)
        else
          raise NameError, "uninitialized constant #{self.name}::#{name}"
        end
      end

      private

      # Gets or sets the path where this module will look for files it autoloads.
      #
      # @param [String] path the path; if path is nil, returns the old path
      # @return [String] the path
      def dynamic_class_path path = nil
        @dynamic_class_path = path if path
        @dynamic_class_path
      end

      # A map of normalized class names to the actual class names.
      #
      # @return [Hash{String=>Symbol}] the map
      def adapter_map
        @adapter_map ||= {}
      end

      # Declare a class as an 'adapter' for this module. Given a name, for example
      # "ChunkyBacon", it will expect the adapter class to be called ChunkyBaconAdapter
      # and be defined in "chunky_bacon_adapter.rb" in this module's #dynamic_class_path.
      #
      # Once a class is declared as an adapter, will set this module to autoload the
      # file on first reference, and sets a key in the #adapter_map mapping the normalized
      # name of the adapter (in the case of ChunkyBaconAdapter, the normalized name is
      # "chunkybacon").
      #
      # The class can be accessed by its normalized name through the #[] method, or simply
      # referenced directly through a #const_missing hook. Using #const_missing will normalize
      # the name of the constant and look it up in the #adapter_map, so capitalization (or even
      # punctuation) need not be exact.
      #
      # @example Setting up a module and a dynamically-loaded adapter
      #   module FunderfulWonderment
      #     extend Animoto::Support::DynamicClassLoader
      #     adapter 'ChunkyBacon'
      #   end
      # 
      # Any reference to FunderfulWonderment::ChunkyBaconAdapter will autoload the class file
      # and return the ChunkyBaconAdapter. As will FunderfulWonderment::Chunky_bacon_ADAPTER or
      # any other name whose normalized name maps to "chunkybacon".
      # 
      # @param [String] name the name of the adapter class, minus the word "Adapter" at the end.
      # @return [void]
      # @see #[]
      # @see #const_missing
      def adapter name
        klass_name = :"#{name}Adapter"
        klass_file = klass_name.to_s.underscore
        self.autoload klass_name, "#{dynamic_class_path}/#{klass_file}"
        adapter_map[normalize_const_name(klass_file)] = klass_name
      end
    
      # Normalizes the name of the missing constant and tries to look it up in the #adapter_map.
      #
      # @param [Symbol] name the name of the constant, as a symbol
      # @return [Class] the class the name corresponds to
      # @raise [NameError] if the class can't be found
      def const_missing name
        if klass_name = adapter_map[normalize_const_name(name)]
          klass = const_get(klass_name)
          const_set name, klass
          klass
        end
      rescue NameError
        super
      end

      # Normalizes a constant name by downcasing it, stripping off the trailing word
      # 'adapter', and removing all non-letter characters. Note that the name should
      # be a valid Ruby constant name.
      #
      # @example
      #   normalize_const_name(:ChunkyBaconAdapter) # => "chunkybacon"
      #
      # @param [String, Symbol] name the name of the class as a String or Symbol
      # @return [String] the normalized name
      def normalize_const_name name
        name.to_s.downcase[/^([\w_]+?)(?:_?adapter)?$/,1].gsub(/[^a-z]/,'')
      end

    end
  end 
end