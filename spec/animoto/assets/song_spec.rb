require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Song do
  
  describe "#to_hash" do
    before do
      @song = Animoto::Assets::Song.new 'http://website.com/song.mp3'
    end
    
    it "should have a 'source_url' key with the url" do
      @song.to_hash.should have_key('source_url')
      @song.to_hash['source_url'].should == @song.source
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
  end
end
