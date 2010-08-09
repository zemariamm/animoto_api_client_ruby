require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Animoto::Project do

  def project *args
    @project ||= begin
      options = args.last.is_a?(Hash) ? args.pop : {}
      Animoto::Project.new(args[0] || "title", options)
    end
  end
  
  describe "initializing" do
    it "should specify the title of the project as the first argument" do
      project("Funderful Wonderment").title.should == "Funderful Wonderment"
    end
    
    it "should default to 'default' pacing" do
      project.pacing.should == 'default'
    end
    
    it "should be able to specify the pacing with a :pacing parameter" do
      project(:pacing => 'double').pacing.should == 'double'
    end
    
    it "should default to 'original' style" do
      project.style.should == 'original'
    end
    
    it "should default to no producer" do
      project.producer.should be_nil
    end
    
    it "should be able to specify the producer with a :producer parameter" do
      project(:producer => "Senor Spielbergo").producer.should == "Senor Spielbergo"
    end
    
    it "should default to having to visuals" do
      project.visuals.should be_empty
    end
  end
  
  describe "adding assets" do
    describe "using the append operator" do
      before do
        @title_card = Animoto::TitleCard.new "woohoo!"
      end
      
      it "should add the asset to this project's visuals" do
        project << @title_card
        project.visuals.should include(@title_card)
      end
      
      it "should raise an error if the object being added isn't a visual" do
        lambda { project << "beef hearts" }.should raise_error
      end
    end
    
    describe "using a convenience method" do
      it "should append the asset to this project's visuals" do
        project.add_title_card("woohoo!")
        vis = project.visuals.last
        vis.should be_an_instance_of(Animoto::TitleCard)
        vis.title.should == "woohoo!"
      end
      
      it "should send the parameters to the asset initializer" do
        project.add_title_card("woohoo!", "everything is great!")
        vis = project.visuals.last
        vis.title.should == "woohoo!"
        vis.subtitle.should == "everything is great!"
      end
    end
  end
  
  describe "adding a song" do
    it "should use the append operator" do
      song = Animoto::Song.new "http://song.org/song.mp3"
      project << song
      project.song.should == song
    end
    
    it "should use the add_song method" do
      song = project.add_song("http://song.org/song.mp3")
      project.song.should == song
    end
    
    it "should replace an existing song" do
      song = Animoto::Song.new "http://song.org/song.mp3"
      song2 = Animoto::Song.new "http://song.org/song2.mp3"
      project << song
      project << song2
      project.song.should == song2
    end
  end
  
  describe "generating a manifest" do
    before do
      project("Funderful Wonderment", :producer => "Senor Spielbergo", :pacing => 'double')
      project.add_image "http://website.com/image.png"
      project.add_title_card "woohoo", "this is awesome"
      project.add_footage "http://website.com/movie.mp4"
      project.add_song "http://website.com/song.mp3"
    end
    
    it "should have top-level 'directing_job' object" do
      project.manifest.should have_key('directing_job')
      project.manifest['directing_job'].should be_a(Hash)
    end
    
    it "should have a 'directing_manifest' object within the 'directing_job'" do
      project.manifest['directing_job'].should have_key('directing_manifest')
      project.manifest['directing_job']['directing_manifest'].should be_a(Hash)
    end
    
    it "should have a 'style' key in the manifest" do
      project.manifest['directing_job']['directing_manifest'].should have_key('style')
      project.manifest['directing_job']['directing_manifest']['style'].should == project.style
    end
  end
end