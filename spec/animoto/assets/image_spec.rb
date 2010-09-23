require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Image do
  
  it "should be a visual" do
    Animoto::Assets::Image.should include(Animoto::Support::Visual)
  end
  
  describe "#to_hash" do
    before do
      @image = Animoto::Assets::Image.new 'http://website.com/image.png'
    end
    
    it "should have a 'source_url' key with the url" do
      @image.to_hash.should have_key('source_url')
      @image.to_hash['source_url'].should == @image.source
    end
    
    describe "if rotated" do
      before do
        @image.rotation = 2
      end
      
      it "should have a 'rotation' key with the EXIF rotation value" do
        @image.to_hash.should have_key('rotation')
        @image.to_hash['rotation'].should == @image.rotation
      end
    end
    
    describe "if spotlit" do
      before do
        @image.spotlit = true
      end
      
      it "should have a 'spotlit' key telling whether or not this image is spotlit" do
        @image.to_hash.should have_key('spotlit')
        @image.to_hash['spotlit'].should == @image.spotlit?
      end
    end
  end
end