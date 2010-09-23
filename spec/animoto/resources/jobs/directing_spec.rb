require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Animoto::Resources::Jobs::Directing do
  
  it "should have endpoint '/jobs/directing'" do
    Animoto::Resources::Jobs::Directing.endpoint.should == '/jobs/directing'
  end
  
  it "should have content type 'application/vnd.animoto.directing_job'" do
    Animoto::Resources::Jobs::Directing.content_type.should == 'directing_job'
  end
  
  it "should have payload key 'directing_job'" do
    Animoto::Resources::Jobs::Directing.payload_key.should == 'directing_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
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
      }
      @job = Animoto::Resources::Jobs::Directing.load @body
    end
    
    it "should set the storyboard url from the body" do
      @job.storyboard_url.should == 'http://animoto.com/storyboards/1'
    end
    
    it "should create a storyboard from the storyboard url" do
      @job.storyboard.should be_an_instance_of(Animoto::Resources::Storyboard)
      @job.storyboard.url.should == @job.storyboard_url
    end
  end
  
end
