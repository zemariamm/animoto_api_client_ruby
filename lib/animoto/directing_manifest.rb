module Animoto
  class DirectingManifest < Animoto::Manifest

    attr_accessor :title, :producer, :pacing, :http_callback_url, :http_callback_format
    attr_reader   :visuals, :song, :style

    def initialize options = {}
      @title      = options[:title]
      @producer   = options[:producer]
      @pacing     = options[:pacing] || 'default'
      @style      = 'original'
      @visuals    = []
      @song       = nil
      @http_callback_url  = options[:http_callback_url]
      @http_callback_format = options[:http_callback_format]
    end

    def add_title_card *args
      card = TitleCard.new *args
      @visuals << card
      card
    end
    
    def add_image *args
      image = Image.new *args
      @visuals << image
      image
    end
    
    def add_footage *args
      footage = Footage.new *args
      @visuals << footage
      footage
    end
    
    def add_song *args
      @song = Song.new *args
    end

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

    def << asset
      add_visual asset
      self
    end

    def to_hash options = {}
      hash = { 'directing_job' => { 'directing_manifest' => {} } }
      job  = hash['directing_job']
      if http_callback_url
        raise ArgumentError if http_callback_format.nil?
        job['http_callback'] = http_callback_url
        job['http_callback_format'] = http_callback_format
      end
      manifest = job['directing_manifest']
      manifest['style'] = style
      manifest['pacing'] = pacing if pacing
      manifest['title'] = title if title
      manifest['producer_name'] = producer if producer
      manifest['visuals'] = []
      visuals.each do |visual|
        manifest['visuals'] << visual.to_hash
      end
      manifest['song'] = song.to_hash if song
      hash
    end
    
  end
end