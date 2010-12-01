module Animoto
  module Manifests
    class Directing < Animoto::Manifests::Base

      # The title of the video project.
      # @return [String]
      attr_accessor :title
      
      # The pacing, representing how quickly the visuals elements will be cycled.
      # Valid values are 'default', 'half', and 'double'.
      # @return [String]
      attr_accessor :pacing
      
      # A URL to receive a callback after directing is finished.
      # @return [String]
      attr_accessor :http_callback_url
      
      # The format of the callback; either 'xml' or 'json'.
      # @return [String]
      attr_accessor :http_callback_format

      # The array of Visual objects in this manifest.
      # @return [Array<Support::Visual>]
      attr_reader   :visuals
      
      # The song for this video.
      # @return [Assets::Song]
      attr_reader   :song
      
      # The 'style' for this video. Currently, the only style available is 'original'.
      # @return [String]
      attr_reader   :style

      # Creates a new directing manifest.
      #
      # @param [Hash] options
      # @option options [String] :title the title of this project
      # @option options [String] :pacing ('default') the pacing for this project
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      # @return [Manifests::Directing] the manifest
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
      # @param [Array<Object>] args arguments sent to the initializer for the TitleCard
      # @return [Assets::TitleCard] the new TitleCard
      # @see Animoto::Assets::TitleCard#initialize
      def add_title_card *args
        card = Assets::TitleCard.new *args
        @visuals << card
        card
      end
    
      # Adds an Image to this manifest.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Image
      # @return [Assets::Image] the new Image
      # @see Animoto::Assets::Image#initialize
      def add_image *args
        image = Assets::Image.new *args
        @visuals << image
        image
      end
    
      # Adds Footage to this manifest.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Footage
      # @return [Assets::Footage] the new Footage
      # @see Animoto::Assets::Footage#initialize
      def add_footage *args
        footage = Assets::Footage.new *args
        @visuals << footage
        footage
      end
    
      # Adds a Song to this manifest. Right now, a manifest can only have one song. Adding
      # a second replaces the first.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Song
      # @return [Assets::Song] the new Song
      # @see Animoto::Assets::Song#initialize
      def add_song *args
        @song = Assets::Song.new *args
      end

      # Adds a visual/song to this manifest.
      #
      # @param [Support::Visual,Assets::Song] asset the asset to add
      # @return [void]
      # @raise [ArgumentError] if the asset isn't a Song or Visual
      def add_visual asset
        case asset
        when Animoto::Assets::Song
          @song = asset
        when Animoto::Support::Visual
          @visuals << asset
        else
          raise ArgumentError
        end      
      end

      # Adds a visual/song to this manifest.
      #
      # @param [Support::Visual,Assets::Song] asset the asset to add
      # @return [self]
      def << asset
        add_visual asset
        self
      end

      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash{String=>Object}] the manifest as a Hash
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
end