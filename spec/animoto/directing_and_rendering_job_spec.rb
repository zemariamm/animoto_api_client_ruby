require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::DirectingAndRenderingJob do
  
  it "should have endpoint '/jobs/directing_and_rendering'" do
    Animoto::DirectingAndRenderingJob.endpoint.should == '/jobs/directing_and_rendering'
  end
  
  it "should have content_type 'application/vnd.animoto.directing_and_rendering_job'" do
    Animoto::DirectingAndRenderingJob.content_type.should == 'directing_and_rendering_job'
  end
  
  it "should have payload key 'directing_and_rendering_job'" do
    Animoto::DirectingAndRenderingJob.payload_key.should == 'directing_and_rendering_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {
        'response' => { 'status' => { 'code' => 200 } },
        'payload' => {
          'directing_and_rendering_job' => {
            'state' => 'completed',
            'links' => {
              'self' => 'http://animoto.com/jobs/directing_and_rendering/1',
              'video' => 'http://animoto.com/videos/1'
            }
          }
        }
      }
      @job = Animoto::DirectingAndRenderingJob.load @body
    end
    
    it "should set the video url from the body" do
      @job.video_url.should == 'http://animoto.com/videos/1'
    end
    
    it "should create a video from the video url" do
      @job.video.should be_an_instance_of(Animoto::Video)
      @job.video.url.should == @job.video_url
    end
  end  
end
