require File.dirname(__FILE__) + '/../../spec_helper'

describe Animoto::HTTPEngines::Base do
  
  describe "autoloading subclasses" do
    before do
      Animoto::HTTPEngines::Base.const_defined?(:BeefHearts).should be_false
    end
    
    
    
    after do
      Animoto::HTTPEngines::Base.remove_const(:BeefHearts)
    end
  end
  
  describe "making a request" do
    before do
      @engine = Animoto::HTTPEngines::Base.new
    end
    
    it "should raise an implementation error" do
      lambda { @engine.request(:get, "http://www.example.com/thing") }.should raise_error(Animoto::AbstractMethodError)
    end
  end
  
end