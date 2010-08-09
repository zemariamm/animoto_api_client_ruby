require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Client do
  def client options = {}
    @client ||= Animoto::Client.new "joe", "secret", options
  end

  def object
    @object ||= Object.new
  end

  describe "supplying credentials" do
    describe "manually" do
      it "should accept the username and password as the first two parameters on initialization" do
        c = Animoto::Client.new "username", "password"
        c.username.should == "username"
        c.password.should == "password"
      end
      
      describe "when the password isn't specified (i.e. only 1 parameter was passed)" do
        it "should raise an error" do
          lambda { Animoto::Client.new "username" }.should raise_error
        end
      end
    end
    
    describe "automatically" do
      before do
        @home_path  = File.expand_path("~/.animotorc")
        @etc_path   = "/etc/.animotorc"
        @config     = "username: joe\npassword: secret"
      end
      
      describe "when ~/.animotorc exists" do
        before do
          File.stubs(:exist?).with(@home_path).returns(true)
          File.stubs(:read).with(@home_path).returns(@config)
        end
        
        it "should configure itself based on the options in ~/.animotorc" do
          c = Animoto::Client.new
          c.username.should == "joe"
          c.password.should == "secret"
        end
      end
      
      describe "when ~/.animotorc doesn't exist" do
        before do
          File.stubs(:exist?).with(@home_path).returns(false)
        end
        
        describe "when /etc/.animotorc exists" do
          before do
            File.stubs(:exist?).with(@etc_path).returns(true)
            File.stubs(:read).with(@etc_path).returns(@config)
          end
          
          it "should configure itself based on the options in /etc/.animotorc" do
            c = Animoto::Client.new
            c.username.should == "joe"
            c.password.should == "secret"
          end
        end
        
        describe "when /etc/.animotorc doesn't exist" do
          it "should raise an error" do
            lambda { Animoto::Client.new }.should raise_error
          end
        end
      end
    end
  end
  
  describe "finding an instance by identifier" do
    before do
      @url = "https://api.animoto.com/storyboards/1"
      @body = {'response'=>{'status'=>{'code'=>200}},'payload'=>{'storyboard'=>{'links'=>{'self'=>@url}}}}
      stub_request(:get, @url).to_return(:body => @body.to_json, :status => [200,"OK"])
    end
    
    it "should make a GET request to the given url" do
      client.find(Animoto::Storyboard, @url)
      WebMock.should have_requested(:get, @url)
    end
    
    it "should ask for a response in the proper format" do
      client.find(Animoto::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:headers => { 'Accept' => "application/vnd.animoto.storyboard-v1+json"})
    end
    
    it "should not sent a request body" do
      client.find(Animoto::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:body => "")
    end
    
    it "should return an instance of the correct resource type" do
      client.find(Animoto::Storyboard, @url).should be_an_instance_of(Animoto::Storyboard)
    end    
  end
  
  describe "reloading an instance" do
    before do
      @url = 'https://api.animoto.com/jobs/directing/1'
      @job = Animoto::DirectingJob.new :state => 'initial', :url => @url
      @body = {'response'=>{'status'=>{'code'=>200}},'payload'=>{'directing_job'=>{'state'=>'retrieving_assets','links'=>{'self'=>@url}}}}
      stub_request(:get, @url).to_return(:body => @body.to_json, :status => [200,"OK"])
      @job.state.should == 'initial' # sanity check
    end
    
    it "should update the resource's attributes" do
      client.reload(@job)
      @job.state.should == 'retrieving_assets'
    end
  end
end