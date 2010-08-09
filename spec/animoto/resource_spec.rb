require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Resource do
  
  def define_thing options = {}
    Object.__send__ :remove_const, :Thing if defined?(Thing)
    Object.__send__ :const_set, :Thing, Class.new(Animoto::Resource)
    options.each { |k,v| Thing.__send__(k, v) }
  end

  describe "inferring the content type" do
    it "should be the underscored, lowercase version of the base class name" do
      class Animoto::ThisIsALongAndStupidName < Animoto::Resource; end
      Animoto::ThisIsALongAndStupidName.content_type.should == 'this_is_a_long_and_stupid_name'
    end
  end

  describe "loading an instance from a response hash" do
    
  end
    
end