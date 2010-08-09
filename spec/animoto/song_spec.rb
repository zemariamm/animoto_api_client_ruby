require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Song do
  
  describe "#to_hash" do
    before do
      @song = Animoto::Song.new 'http://website.com/song.mp3'
    end
    
    it "should have a 'source_url' key with the url" do
      @song.to_hash.should have_key('source_url')
      @song.to_hash['source_url'].should == @song.source_url
    end
    
    describe "if a start time was specified" do
      before do
        @song.start_time = 30.2
      end
      
      it "should have a 'start_time' key with the start time" do
        @song.to_hash.should have_key('start_time')
        @song.to_hash['start_time'].should == @song.start_time
      end
    end
    
    describe "if a duration was specified" do
      before do
        @song.duration = 300
      end
      
      it "should have a 'duration' key with the duration" do
        @song.to_hash.should have_key('duration')
        @song.to_hash['duration'].should == @song.duration
      end
    end
    
    describe "if a title and/or artist was specified" do
      before do
        @song.title = "Antarctican Drinking Song"
        @song.artist = "Gwar"
      end
      
      it "should have an 'artist' key with the artist" do
        @song.to_hash.should have_key('artist')
        @song.to_hash['artist'].should == @song.artist
      end
      
      it "should have a 'title' key with the title" do
        @song.to_hash.should have_key('title')
        @song.to_hash['title'].should == @song.title
      end
    end
  end
end
