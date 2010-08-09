require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::RenderingJob do
  
  it "should have endpoint /jobs/rendering" do
    Animoto::RenderingJob.endpoint.should == '/jobs/rendering'
  end
  
  it "should have content type 'application/vnd.animoto.rendering_job'" do
    Animoto::RenderingJob.content_type.should == 'rendering_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {}
    end
    
    
  end
  
end
