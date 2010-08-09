module Animoto
  class Project < Animoto::Resource

    attr_accessor :title, :producer, :pacing
    attr_reader   :visuals, :song, :style

    def initialize title, options = {}
      @title    = title
      @producer = options[:producer]
      @pacing   = options[:pacing] || 'default'
      @style    = 'original'
      @visuals  = []
      @song     = nil
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

    def manifest options = {}
      
    end
    
  end
end