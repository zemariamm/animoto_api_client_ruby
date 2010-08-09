require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::TitleCard do
  
  it "should be a visual" do
    Animoto::TitleCard.should include(Animoto::Visual)
  end
  
  describe "#to_hash" do
    before do
      @card = Animoto::TitleCard.new("hooray")
    end
    
    it "should have an 'h1' key with the title" do
      @card.to_hash.should have_key('h1')
      @card.to_hash['h1'].should == @card.title
    end

    describe "if there is a subtitle" do
      before do
        @card.subtitle = "for everything!"
      end

      it "should have an 'h2' key with the subtitle" do
        @card.to_hash.should have_key('h2')
        @card.to_hash['h2'].should == @card.subtitle
      end
    end
    
    describe "if spotlit" do
      before do
        @card.spotlit = true
      end
      
      it "should have a 'spotlit' key telling whether or not it is spotlit" do
        @card.to_hash.should have_key('spotlit')
        @card.to_hash['spotlit'].should == @card.spotlit?
      end
    end
  end
  
end
