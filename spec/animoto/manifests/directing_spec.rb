require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::Manifests::Directing do

  def manifest options = {}
    @manifest ||= Animoto::Manifests::Directing.new(options)
  end
  
  describe "initializing" do
    it "should specify the title of the manifest as the first argument" do
      manifest(:title => "Funderful Wonderment").title.should == "Funderful Wonderment"
    end
    
    it "should default to 'default' pacing" do
      manifest.pacing.should == 'default'
    end
    
    it "should be able to specify the pacing with a :pacing parameter" do
      manifest(:pacing => 'double').pacing.should == 'double'
    end
    
    it "should default to 'original' style" do
      manifest.style.should == 'original'
    end
    
    it "should default to having to visuals" do
      manifest.visuals.should be_empty
    end
  end
  
  describe "adding assets" do
    describe "using the append operator" do
      before do
        @title_card = Animoto::Assets::TitleCard.new "woohoo!"
      end
      
      it "should add the asset to this manifest's visuals" do
        manifest << @title_card
        manifest.visuals.should include(@title_card)
      end
      
      it "should raise an error if the object being added isn't a visual" do
        lambda { manifest << "beef hearts" }.should raise_error
      end
    end
    
    describe "using a convenience method" do
      it "should append the asset to this manifest's visuals" do
        manifest.add_title_card("woohoo!")
        vis = manifest.visuals.last
        vis.should be_an_instance_of(Animoto::Assets::TitleCard)
        vis.title.should == "woohoo!"
      end
      
      it "should send the parameters to the asset initializer" do
        manifest.add_title_card("woohoo!", "everything is great!")
        vis = manifest.visuals.last
        vis.title.should == "woohoo!"
        vis.subtitle.should == "everything is great!"
      end
    end
  end
  
  describe "adding a song" do
    it "should use the append operator" do
      song = Animoto::Assets::Song.new "http://song.org/song.mp3"
      manifest << song
      manifest.song.should == song
    end
    
    it "should use the add_song method" do
      song = manifest.add_song("http://song.org/song.mp3")
      manifest.song.should == song
    end
    
    it "should replace an existing song" do
      song = Animoto::Assets::Song.new "http://song.org/song.mp3"
      song2 = Animoto::Assets::Song.new "http://song.org/song2.mp3"
      manifest << song
      manifest << song2
      manifest.song.should == song2
    end
  end
  
  describe "generating a hash" do
    before do
      manifest(:title => 'Funderful Wonderment', :pacing => 'double')
      @image = manifest.add_image 'http://website.com/image.png'
      @title_card = manifest.add_title_card 'woohoo', 'this is awesome'
      @footage = manifest.add_footage 'http://website.com/movie.mp4'
      @song_obj = manifest.add_song 'http://website.com/song.mp3'
    end
    
    it "should have top-level 'directing_job' object" do
      manifest.to_hash.should have_key('directing_job')
      manifest.to_hash['directing_job'].should be_a(Hash)
    end
    
    it "should have a 'directing_manifest' object within the 'directing_job'" do
      manifest.to_hash['directing_job'].should have_key('directing_manifest')
      manifest.to_hash['directing_job']['directing_manifest'].should be_a(Hash)
    end
    
    it "should have a 'style' key in the manifest" do
      manifest.to_hash['directing_job']['directing_manifest'].should have_key('style')
      manifest.to_hash['directing_job']['directing_manifest']['style'].should == manifest.style
    end
    
    it "should have a 'pacing' key in the manifest" do
      manifest.to_hash['directing_job']['directing_manifest'].should have_key('pacing')
      manifest.to_hash['directing_job']['directing_manifest']['pacing'].should == manifest.pacing
    end
    
    it "should have a 'visuals' key in the manifest" do
      manifest.to_hash['directing_job']['directing_manifest'].should have_key('visuals')
    end
    
    it "should have a 'song' object in the manifest" do
      manifest.to_hash['directing_job']['directing_manifest'].should have_key('song')
      manifest.to_hash['directing_job']['directing_manifest']['song'].should be_a(Hash)
    end
    
    describe "when the callback url is set" do
      before do
        manifest.http_callback_url = 'http://website.com/callback'        
      end

      describe "but the callback format isn't" do
        it "should raise an error" do
          lambda { manifest.to_hash }.should raise_error(ArgumentError)
        end
      end
      
      describe "as well as the format" do
        before do
          manifest.http_callback_format = 'xml'
        end
        
        it "should have the HTTP callback URL in the job" do
          manifest.to_hash['directing_job'].should have_key('http_callback')
          manifest.to_hash['directing_job']['http_callback'].should == manifest.http_callback_url
        end

        it "should have the HTTP callback format in the job" do
          manifest.to_hash['directing_job'].should have_key('http_callback_format')
          manifest.to_hash['directing_job']['http_callback_format'].should == manifest.http_callback_format
        end
      end
    end
    
    describe "visuals array" do
      before do
        @visuals = manifest.to_hash['directing_job']['directing_manifest']['visuals']
      end
      
      it "should have the visuals in the order they were added" do
        @visuals[0].should == @image.to_hash
        @visuals[1].should == @title_card.to_hash
        @visuals[2].should == @footage.to_hash
      end
    end
    
    describe "song" do
      before do
        @song = manifest.to_hash['directing_job']['directing_manifest']['song']
      end
      
      it "should have info about the song" do
        @song.should == @song_obj.to_hash
      end
    end
  end
end