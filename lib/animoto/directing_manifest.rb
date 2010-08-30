module Animoto
  class DirectingManifest < Animoto::Manifest

    attr_accessor :title, :pacing, :http_callback_url, :http_callback_format
    attr_reader   :visuals, :song, :style

    # Creates a new DirectingManifest.
    #
    # @param [Hash] options
    # @option options [String] :title the title of this project
    # @option options ['default','half','double'] :pacing ('default') the pacing for this project
    # @option options [String] :http_callback_url a URL to receive a callback when this job is done
    # @option options ['json','xml'] :http_callback_format the format of the callback
    def initialize options = {}
      @title      = options[:title]
      @pacing     = options[:pacing] || 'default'
      @style      = 'original'
      @visuals    = []
      @song       = nil
      @http_callback_url  = options[:http_callback_url]
      @http_callback_format = options[:http_callback_format]
    end

    # Adds a TitleCard to this manifest.
    #
    # @see TitleCard
    # @return [TitleCard] the new TitleCard
    def add_title_card *args
      card = TitleCard.new *args
      @visuals << card
      card
    end
    
    # Adds an Image to this manifest.
    #
    # @see Image
    # @return [Image] the new Image
    def add_image *args
      image = Image.new *args
      @visuals << image
      image
    end
    
    # Adds Footage to this manifest.
    #
    # @see Footage
    # @return [Footage] the new Footage
    def add_footage *args
      footage = Footage.new *args
      @visuals << footage
      footage
    end
    
    # Adds a Song to this manifest. Right now, a manifest can only have one song. Adding
    # a second replaces the first.
    #
    # @see Song
    # @return [Song] the new Song
    def add_song *args
      @song = Song.new *args
    end

    # Adds a visual/song to this manifest.
    #
    # @param [Visual,Song] asset the asset to add
    # @raise [ArgumentError] if the asset isn't a Song or Visual
    def add_visual asset
      case asset
      when Animoto::Song
        @song = asset
      when Animoto::Visual
        @visuals << asset
      else
        raise ArgumentError
      end      
    end

    # Adds a visual/song to this manifest.
    #
    # @param [Visual,Song] asset the asset to add
    # @return [self]
    def << asset
      add_visual asset
      self
    end

    # Returns a representation of this manifest as a Hash.
    #
    # @return [Hash] the manifest as a Hash
    # @raise [ArgumentError] if a callback URL is specified but not the format
    def to_hash options = {}
      hash = { 'directing_job' => { 'directing_manifest' => {} } }
      job  = hash['directing_job']
      if http_callback_url
        raise ArgumentError, "You must specify a http_callback_format (either 'xml' or 'json')" if http_callback_format.nil?
        job['http_callback'] = http_callback_url
        job['http_callback_format'] = http_callback_format
      end
      manifest = job['directing_manifest']
      manifest['style'] = style
      manifest['pacing'] = pacing if pacing
      manifest['title'] = title if title
      manifest['visuals'] = []
      visuals.each do |visual|
        manifest['visuals'] << visual.to_hash
      end
      manifest['song'] = song.to_hash if song
      hash
    end
    
  end
end