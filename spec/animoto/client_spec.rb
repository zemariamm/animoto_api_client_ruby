require 'base64'
require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Client do
  def client options = {}
    @client ||= Animoto::Client.new "joe", "secret", options.merge(:logger => ::Logger.new('/dev/null'))
  end

  def object
    @object ||= Object.new
  end

  describe "supplying credentials and endpoint" do
    describe "manually" do
      it "should accept the key and secret as the first two parameters on initialization" do
        c = Animoto::Client.new "key", "secret"
        c.key.should == "key"
        c.secret.should == "secret"
      end
      
      it "should accept an endpoint as an option" do
        c = Animoto::Client.new "key", "secret", :endpoint => "https://api.animoto.com/"
        c.endpoint.should == "https://api.animoto.com/"
      end
      
      describe "when the secret isn't specified (i.e. only 1 parameter was passed)" do
        before do
          File.stubs(:exist?).returns(false) # <= to keep it from finding our .animotorc files
        end
        
        it "should raise an error" do
          lambda { Animoto::Client.new "key" }.should raise_error
        end
      end
      
      describe "when the endpoint isn't specified" do
        it "should set the endpoint to the default" do
          c = Animoto::Client.new "key", "secret"
          c.endpoint.should == Animoto::Client::API_ENDPOINT
        end
      end
    end
    
    describe "automatically" do
      before do
        @here_path  = File.expand_path("./.animotorc")
        @home_path  = File.expand_path("~/.animotorc")
        @etc_path   = "/etc/.animotorc"
        @config     = "key: joe\nsecret: secret\nendpoint: https://api.animoto.com/"
      end
      
      describe "when ./.animotorc exists" do
        before do
          File.stubs(:exist?).with(@here_path).returns(true)
          File.stubs(:read).with(@here_path).returns(@config)
        end
        
        it "should configure itself based on the options in ~/.animotorc" do
          c = Animoto::Client.new
          c.key.should == "joe"
          c.secret.should == "secret"
          c.endpoint.should == "https://api.animoto.com/"
        end
      end
      
      describe "when ./.animotorc doesn't exist" do
        before do
          File.stubs(:exist?).with(@here_path).returns(false)
        end
        
        describe "when ~/.animotorc exists" do
          before do
            File.stubs(:exist?).with(@home_path).returns(true)
            File.stubs(:read).with(@home_path).returns(@config)
          end
        
          it "should configure itself based on the options in ~/.animotorc" do
            c = Animoto::Client.new
            c.key.should == "joe"
            c.secret.should == "secret"
            c.endpoint.should == "https://api.animoto.com/"
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
              c.key.should == "joe"
              c.secret.should == "secret"
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
  end
    
  describe "finding an instance by identifier" do
    before do
      @url = "https://joe:secret@api.animoto.com/storyboards/1"
      hash = {'response'=>{'status'=>{'code'=>200},'payload'=>{'storyboard'=>{'links'=>{'self'=>@url,'preview'=>'http://animoto.com/preview/1.mp4'},'metadata'=>{'duration'=>100,'visuals_count'=>1}}}}}
      body = client.response_parser.unparse(hash)
      stub_request(:get, @url).to_return(:body => body, :status => [200,"OK"])
    end
    
    it "should make a GET request to the given url" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url)
    end
    
    it "should ask for a response in the proper format" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:headers => { 'Accept' => "application/vnd.animoto.storyboard-v1+json" })
    end
    
    it "should not sent a request body" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:body => "")
    end
    
    it "should return an instance of the correct resource type" do
      client.find(Animoto::Resources::Storyboard, @url).should be_an_instance_of(Animoto::Resources::Storyboard)
    end    
  end
  
  describe "reloading an instance" do
    before do
      @url = 'https://joe:secret@api.animoto.com/jobs/directing/1'
      @job = Animoto::Resources::Jobs::Directing.new :state => 'initial', :url => @url
      hash = {'response'=>{'status'=>{'code'=>200},'payload'=>{'directing_job'=>{'state'=>'retrieving_assets','links'=>{'self'=>@url,'storyboard'=>'http://api.animoto.com/storyboards/1'}}}}}
      body = client.response_parser.unparse(hash)
      stub_request(:get, @url).to_return(:body => body, :status => [200,"OK"])
      @job.state.should == 'initial' # sanity check
    end
    
    it "should update the resource's attributes" do
      client.reload!(@job)
      @job.state.should == 'retrieving_assets'
    end
  end
end