require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Animoto::Project do

  def project options = {}
    @project ||= Animoto::Project.new options
  end
  
  describe "directing" do
    it "should create a new DirectingJob" do
      project.direct!.should be_an_instance_of(Animoto::DirectingJob)
    end
  end
end