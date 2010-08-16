module Animoto
  class HTTPEngine

    # If a reference is made to a class under this one that hasn't been initialized yet,
    # this will attempt to require a file with that class' name (underscored). If one is
    # found, and the file defines the class requested, will return that class object.
    #
    # @param [Symbol] const the uninitialized class' name
    # @return [Class] the class found
    # @raise [NameError] if the file defining the class isn't found, or if the file required
    #   doesn't define the class.
    def self.const_missing const
      engine_name = const.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      file_name = File.dirname(__FILE__) + "/response_parsers/#{engine_name}.rb"
      if File.exist?(file_name)
        require file_name
        const_defined?(const) ? const_get(const) : super
      else
        super
      end
    end
    
    def self.[] engine
      const_get engine
    end
    
    def self.format
      @format
    end
    
    def format
      self.class.format
    end
        
    def parse body
      raise NotImplementedError
    end
    
    def unparse hash
      raise NotImplementedError
    end

  end
end