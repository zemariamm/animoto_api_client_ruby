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
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          }
        },
        'payload' => {
          'directing_job' => {
            'state' => 'completed',
            'links' => {
              'self' => 'http://animoto.com/jobs/directing/1',
              'storyboard' => 'http://animoto.com/storyboards/1'
            }
          }
        }
      }
      @job = Animoto::DirectingJob.new @body
    end
    
    it "should set the storyboard url from the body" do
      @job.storyboard_url.should == 'http://animoto.com/storyboards/1'
    end
    
    it "should create a storyboard from the storyboard url" do
      @job.storyboard.should be_an_instance_of(Animoto::Storyboard)
      @job.storyboard.url.should == @job.storyboard_url
    end
  end
  
end
