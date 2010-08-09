require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::RenderingJob do
  
  it "should have endpoint /jobs/rendering" do
    Animoto::RenderingJob.endpoint.should == '/jobs/rendering'
  end
  
  it "should have content type 'application/vnd.animoto.rendering_job'" do
    Animoto::RenderingJob.content_type.should == 'rendering_job'
  end
  
  it "should have payload key 'rendering_job'" do
    Animoto::RenderingJob.payload_key.should == 'rendering_job'
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
          'rendering_job' => {
            'state' => 'completed',
            'links' => {
              'self' => 'http://animoto.com/jobs/rendering/1',
              'storyboard' => 'http://animoto.com/storyboards/1',
              'video' => 'http://animoto.com/videos/1'
            }
          }
        }
      }
      @job = Animoto::RenderingJob.load @body
    end
    
    it "should set the storyboard url from the body" do
      @job.storyboard_url.should == "http://animoto.com/storyboards/1"
    end
    
    it "should set the video url from the body" do
      @job.video_url.should == "http://animoto.com/videos/1"
    end
    
    it "should create a storyboard from the storyboard url" do
      @job.storyboard.should be_an_instance_of(Animoto::Storyboard)
      @job.storyboard.url.should == @job.storyboard_url
    end
    
    it "should create a video from the video url" do
      @job.video.should be_an_instance_of(Animoto::Video)
      @job.video.url.should == @job.video_url
    end
  end
  
end
