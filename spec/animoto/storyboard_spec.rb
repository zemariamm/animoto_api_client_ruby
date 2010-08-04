require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Storyboard do
  def storyboard options = {}
    @storyboard ||= Animoto::Storyboard.new options
  end
  
  describe "rendering" do
    it "should create a new RenderingJob" do
      storyboard.render!.should be_an_instance_of(Animoto::RenderingJob)
    end
  end
end
