module Animoto
  module DynamicClassLoader
    
    # If a reference is made to a class under this one that hasn't been initialized yet,
    # this will attempt to require a file with that class' name (underscored). If one is
    # found, and the file defines the class requested, will return that class object.
    #
    # @param [Symbol] const the uninitialized class' name
    # @return [Class] the class found
    # @raise [NameError] if the file defining the class isn't found, or if the file required
    #   doesn't define the class.
    def const_missing const
      engine_name = underscore_class_name(const.to_s)
      file_name = File.dirname(__FILE__) + "/#{search_path}/#{engine_name}.rb"
      if File.exist?(file_name)
        require file_name
        const_defined?(const) ? const_get(const) : super
      else
        super
      end
    end
            
    # Returns the adapter class for the given symbol. If the file defining the class
    # hasn't been loaded, will try to load it.
    #
    # @param [Symbol] engine the symbolic name of the adapter
    # @return [Class] the class
    # @raise [NameError] if the class isn't found
    def [] engine
      require(File.dirname(__FILE__) + "/#{search_path}/#{engine.to_s.gsub(/[^\w]/,'.?')}_adapter.rb") unless $".grep(/#{engine.to_s}_adapter/).first
    rescue LoadError
      raise NameError, "Couldn't locate adapter named \"#{engine}\""
    else
      adapter_map[engine]      
    end

    private

    # Returns the path relative to this file where dynamically loaded files can be found.
    # Defaults to the underscored class name plus 's'.
    #
    # @return [String] the path
    def search_path
      "#{underscore_class_name(self)}s"
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