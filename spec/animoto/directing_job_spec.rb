require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::DirectingJob do
  
  it "should have endpoint '/jobs/directing'" do
    Animoto::DirectingJob.endpoint.should == '/jobs/directing'
  end
  
  it "should have content type 'application/vnd.animoto.directing_job'" do
    Animoto::DirectingJob.content_type.should == 'directing_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {}
    end
    
  end
  
end
