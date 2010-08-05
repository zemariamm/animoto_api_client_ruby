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

  it "should default to a json response format" do
    client.response_format.should == :json
  end
  
  describe "setting a response format" do
    it "should raise an error if the format isn't supported" do
      lambda { client.response_format = :yaml }.should raise_error
    end
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
  
  describe "finding an instance by identifier" do
    before do
      @storyboard = Animoto::Storyboard.new
      @id = 1
    end
    
    it "should make a GET request" do
      client.expects(:request).with(:get, anything)
      client.find(Animoto::Storyboard, @id)
    end
    
    it "should request the endpoint affixed with the identifier" do
      url = "#{Animoto::Client::API_ENDPOINT}#{Animoto::Storyboard.endpoint}/#{@id}"
      client.expects(:request).with(anything, url)
      client.find(Animoto::Storyboard, @id)
    end
    
    it "should ask for the correct content-type" do
      content_type = "#{Animoto::Client::BASE_CONTENT_TYPE}.#{Animoto::Storyboard.content_type}+#{client.response_format}"
      client.expects(:request).with(anything, anything, has_entry(:accept => content_type))
      client.find(Animoto::Storyboard, @id)
    end
    
    it "should not sent a request body" do
      client.expects(:request).with(anything, anything, Not(has_entry(:body => regexp_matches(/^.+$/))))
      client.find(Animoto::Storyboard, @id)
    end
  end
  
  describe "creating an instance" do
    before do
      @storyboard = Animoto::Storyboard.new
    end
    
    it "should make a POST request" do
      client.expects(:request).with(:post, anything, anything)
      client.create(@storyboard)
    end
    
    it "should request the endpoint" do
      url = "#{Animoto::Client::API_ENDPOINT}#{Animoto::Storyboard.endpoint}"
      client.expects(:request).with(anything, url, anything)
      client.create(@storyboard)
    end
    
    it "should ask for a response in the proper format" do
      content_type = "application/#{client.response_format}"
      client.expects(:request).with(anything, anything, has_entry(:accept => content_type))
      client.create(@storyboard)
    end
    
    it "should send the request body" do
      client.expects(:request).with(anything, anything, has_entry(:body => @storyboard.to_request_body))
      client.create(@storyboard)
    end
  end
  
  describe "destroying an instance" do
    before do
      @storyboard = Animoto::Storyboard.new
      @id = 1
      @storyboard.instance_variable_set :@id, @id
    end
    
    it "should make a DELETE request" do
      client.expects(:request).with(:delete, anything, anything)
      client.destroy(@storyboard)
    end
    
    it "should request the endpoint affixed with the identifier" do
      url = "#{Animoto::Client::API_ENDPOINT}#{Animoto::Storyboard.endpoint}"
      client.expects(:request).with(anything, url, anything)
      client.destroy(@storyboard)
    end
    
    it "should ask for the correct response format" do
      content_type = "application/#{client.response_format}"
      client.expects(:request).with(anything, anything, has_entry(:accept => content_type))
      client.destroy(@storyboard)
    end
    
    it "should not send a request body" do
      client.expects(:request).with(anything, anything, Not(has_entry(:body => regexp_matches(/^.+$/))))
      client.destroy(@storyboard)
    end
  end
end