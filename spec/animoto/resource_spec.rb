require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Resource do
  
  def define_thing options = {}
    Object.__send__ :remove_const, :Thing if defined?(Thing)
    Object.__send__ :const_set, :Thing, Class.new(Animoto::Resource)
    options.each { |k,v| Thing.__send__(k, v) }
  end
    
  describe "generating a request body" do
    before do
      define_thing
      @thing = Thing.new  
    end
    
    it "should default to returning an empty hash" do
      @thing.to_request_body.should == {}
    end
  end
    
  describe "loading an instance from a response body" do
    
  end
end