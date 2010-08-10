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

  describe "identity mapping" do
    before do
      @url = "https://api.animoto.com/videos/1"
      @video = Animoto::Video.new :url => @url
      @body = {
        'response' => {
          'status' => { 'code' => 200 },
          'payload' => {
            'video' => {
              'links' => {
                'download' => "http://animoto.com/videos/1",
                'storyboard' => "https://api.animoto.com/storyboards/1",
                'self' => @url
              },
              'metadata' => {
                'duration' => 300,
                'format' => 'h264',
                'framerate' => 30,
                'vertical_resolution' => "720p"
              }
            }
          }
        }
      }
    end
    
    it "should ensure that two instances instantiated with the same unique identifier will both be the same object" do
      @video.should equal(Animoto::Video.load(@body))
    end
    
    it "should update the original instance with the initialization parameters of the new one" do
      @video.duration.should be_nil
      video = Animoto::Video.load(@body)
      video.duration.should == 300
      @video.duration.should == 300
    end
  end
end