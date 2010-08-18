require File.dirname(__FILE__) + '/../spec_helper'

describe Animoto::HTTPEngine do
  
  describe "autoloading subclasses" do
    before do
      Animoto::HTTPEngine.const_defined?(:BeefHearts).should be_false
    end
    
    
    
    after do
      Animoto::HTTPEngine.remove_const(:BeefHearts)
    end
  end
  
  describe "making a request" do
    before do
      @engine = Animoto::HTTPEngine.new
    end
    
    it "should raise an implementation error" do
      lambda { @engine.request(:get, "http://www.example.com/thing") }.should raise_error(NotImplementedError)
    end
  end
  
end