require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Animoto::Manifest do

  def manifest options = {}
    @manifest ||= Animoto::Manifest.new options
  end
  
  describe "directing" do
    it "should create a new DirectingJob" do
      manifest.direct!.should be_an_instance_of(Animoto::DirectingJob)
    end
  end
end