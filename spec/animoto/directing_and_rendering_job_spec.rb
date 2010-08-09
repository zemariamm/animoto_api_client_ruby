require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::DirectingAndRenderingJob do
  
  it "should have endpoint '???'" do
    fail
  end
  
  it "should have content_type 'application/vnd.animoto.directing_and_rendering_job'" do
    Animoto::DirectingAndRenderingJob.content_type.should == 'directing_and_rendering_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {}
    end
    
    
  end
  
end
