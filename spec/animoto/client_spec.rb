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

  describe "setting the HTTP engine" do
    it "should default to 'net/http'" do
      client.http_engine.name.should == :net_http
    end
    
    describe "on initialization" do
      it "should accept an :http_engine parameter with the symbolic name of an engine to use" do
        client(:http_engine => :curl)
        client.http_engine.name.should == :curl
      end

      it "should accept an :http_engine parameter with an object to use" do
        client(:http_engine => object)
        client.http_engine.should == object
      end
    end
    
    it "should accept the symbolic name of an engine to use" do
      client.http_engine = :curl
      client.http_engine.name.should == :curl
    end
    
    it "should accept an object to use" do
      client.http_engine = object
      client.http_engine.should == object
    end
  end
  
  describe "setting the response parser" do
    it "should default to 'json'" do
      client.response_parser.name.should == :json
    end
    
    describe "on initialization" do
      it "should accept an :response_parser parameter with the symbolic name of an parser to use" do
        client(:response_parser => :nokogiri)
        client.response_parser.name.should == :nokogiri
      end

      it "should accept an :response_parser parameter with an object to use" do
        client(:response_parser => object)
        client.response_parser.should == object
      end
    end
    
    it "should accept the symbolic name of an parser to use" do
      client.response_parser = :nokogiri
      client.response_parser.name.should == :nokogiri
    end
    
    it "should accept an object to use" do
      client.response_parser = object
      client.response_parser.should == object
    end    
  end
  
  describe "deciding which format (JSON or XML) to request" do
    
  end
  
  describe "making a request" do
    describe "building the request URL" do
      
    end
    
    describe "setting the Content-Type header" do
      
    end
    
    describe "building the request body" do
      
    end
    
    describe "using the correct HTTP verb" do
      
    end
  end
  
  describe "creating resources" do
    it "should return an instance of the named resource" do
      client.resource(:storyboard).should be_an_instance_of(Animoto::Storyboard)
    end
    
    it "should delegate any given options of the resource initialization" do
      options = { :hooray_for => :everything! }
      Animoto::Storyboard.expects(:new).with(anything, options)
      client.resource(:storyboard, options)
    end
    
    it "should yield the new instance to a given block" do
      Animoto::Storyboard.expects(:new).returns(storyboard = stub('storyboard!'))
      storyboard.expects(:hooray!)
      client.returns(:storyboard) { |s| s.hooray! }
    end
  end
  
  describe "#method_missing" do
    describe "when the method name corresponds to a resource" do
      before do
        # little sanity check here
        client.should_not respond_to(:storyboard)
      end
      
      it "should call #resource with the named resource" do
        client.expects(:resource).with(:storyboard)
        client.storyboard
      end
      
      it "should delegate any parameters to the #resource call" do
        options = { :hooray_for => :everything! }
        client.expects(:resource).with(:storyboard, options)
        client.storyboard(options)
      end
    end
  end

end