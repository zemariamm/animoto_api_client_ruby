require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Animoto::Resources::Jobs::Base do
  
  before do
    Animoto::Resources::Jobs::Base.payload_key('job')
  end
  
  describe "initialization" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'job' => {
              'state' => 'initial',
              'links' => {
                'self' => "http://animoto.com/jobs/1"
              }
            }
          }
        }
      }
      @job = Animoto::Resources::Jobs::Base.load @body
    end
    
    it "should set its state from the job state given" do
      @job.state.should == 'initial'
    end
    
    it "should set its url from the 'self' link given" do
      @job.url.should == 'http://animoto.com/jobs/1'
    end
  end
  
  describe "when there are errors" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 400,
            'errors' => [
              {
                'code' => 'FORMAT',
                'description' => 'There is an item in the request that is incorrectly formatted'
              }
            ]
          },
          'payload' => {
            'job' => {
              'state' => 'failed',
              'links' => {
                'self' => 'http://animoto.com/jobs/1'
              }
            }
          }
        }
      }
      @job = Animoto::Resources::Jobs::Base.load @body
    end
    
    it "should have 'failed' state" do
      @job.state.should == 'failed'
    end
    
    it "should have non-empty errors" do
      @job.errors.should_not be_empty
    end
    
    it "should wrap the errors in error objects" do
      @job.errors.first.should be_an_instance_of(Animoto::Error)
    end
  end
  
  describe "returning state" do
    before do
      @job = Animoto::Resources::Jobs::Base.load 'response'=>{'status'=>{'code'=>200},'payload'=>{'job'=>{'state'=>'initial','links'=>{'self'=>'http://animoto.com/jobs/1'}}}}
    end
    
    describe "when 'initial'" do
      it "should not be failed" do
        @job.should_not be_failed
      end
      
      it "should not be completed" do
        @job.should_not be_completed
      end
      
      it "should be pending" do
        @job.should be_pending
      end
    end
    
    describe "when 'failed'" do
      before do
        @job.instance_variable_set :@state, 'failed'
      end
      
      it "should be failed" do
        @job.should be_failed
      end
      
      it "should not be completed" do
        @job.should_not be_completed
      end
      
      it "should not be pending" do
        @job.should_not be_pending
      end
    end
    
    describe "when 'completed'" do
      before do
        @job.instance_variable_set :@state, 'completed'
      end
      
      it "should not be failed" do
        @job.should_not be_failed
      end
      
      it "should be completed" do
        @job.should be_completed
      end
      
      it "should not be pending" do
        @job.should_not be_pending
      end
    end
  end
end