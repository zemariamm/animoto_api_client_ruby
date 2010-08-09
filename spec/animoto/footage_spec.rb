require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Footage do
  
  it "should be a visual" do
    Animoto::Footage.should include(Animoto::Visual)
  end
  
  describe "#to_hash" do
    before do
      @footage = Animoto::Footage.new 'http://website.com/movie.mp4'
    end
    
    it "should have a 'source_url' key with the url" do
      @footage.to_hash.should have_key('source_url')
      @footage.to_hash['source_url'].should == @footage.source_url
    end
    
    it "should not have a 'spotlit' key" do
      @footage.to_hash.should_not have_key('spotlit')
    end
    
    describe "if audio mixing is turned on" do
      before do
        @footage.audio_mix = true
      end
      
      it "should have an 'audio_mix' key telling how to mix" do
        @footage.to_hash.should have_key('audio_mix')
        @footage.to_hash['audio_mix'].should == 'MIX'
      end
    end
    
    describe "if using a different start time" do
      before do
        @footage.start_time = 10.5
      end
      
      it "should have a 'start_time' key with the starting time" do
        @footage.to_hash.should have_key('start_time')
        @footage.to_hash['start_time'].should == @footage.start_time
      end
    end
    
    describe "if a duration was specified" do
      before do
        @footage.duration = 300
      end
      
      it "should have a 'duration' key with the duration" do
        @footage.to_hash.should have_key('duration')
        @footage.to_hash['duration'].should == @footage.duration
      end
    end
  end
end
