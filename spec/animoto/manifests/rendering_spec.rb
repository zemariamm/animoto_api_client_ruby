require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::Manifests::Rendering do
  
  def manifest *args
    @manifest ||= begin
      options = args.last.is_a?(Hash) ? args.pop : {}
      @storyboard = args[0] || Animoto::Resources::Storyboard.new
      Animoto::Manifests::Rendering.new @storyboard, options
    end
  end
  
  describe "initialization" do
    before do
      @storyboard = Animoto::Resources::Storyboard.new
    end
    
    it "should take a storyboard as the first argument" do
      Animoto::Manifests::Rendering.new(@storyboard).storyboard = @storyboard
    end
    
    it "should take a :resolution parameter to set the resolution" do
      manifest(:resolution => "720p").resolution.should == "720p"
    end
    
    it "should take a :framerate parameter to set the framerate" do
      manifest(:framerate => 24).framerate.should == 24
    end
    
    it "should take a :format parameter to set the format" do
      manifest(:format => 'flv').format.should == 'flv'
    end
    
    it "should take :http_callback_url and :http_callback_format parameters to set the callback" do
      manifest(:http_callback_url => "http://website.com/callback", :http_callback_format => 'xml')
      manifest.http_callback_url.should == "http://website.com/callback"
      manifest.http_callback_format.should == 'xml'
    end
  end
  
  describe "generating a hash" do
    before do
      @storyboard = Animoto::Resources::Storyboard.new
      @url = "http://animoto.com/storyboards/1"
      @storyboard.instance_variable_set(:@url, @url)
      manifest(@storyboard, :resolution => "720p", :framerate => 24, :format => 'flv')
    end
    
    it "should have a top-level 'rendering_job' object" do
      manifest.to_hash.should have_key('rendering_job')
      manifest.to_hash['rendering_job'].should be_a(Hash)
    end
    
    it "should have a 'rendering_manifest' object in the 'rendering_job'" do
      manifest.to_hash['rendering_job'].should have_key('rendering_manifest')
      manifest.to_hash['rendering_job']['rendering_manifest'].should be_a(Hash)
    end
    
    it "should have a 'storyboard_url' key in the manifest" do
      manifest.to_hash['rendering_job']['rendering_manifest'].should have_key('storyboard_url')
      manifest.to_hash['rendering_job']['rendering_manifest']['storyboard_url'].should == @storyboard.url
    end
    
    it "should have a 'rendering_parameters' object in the manifest" do
      manifest.to_hash['rendering_job']['rendering_manifest'].should have_key('rendering_parameters')
      manifest.to_hash['rendering_job']['rendering_manifest']['rendering_parameters'].should be_a(Hash)
    end
    
    describe "rendering parameters" do
      before do
        @profile = manifest.to_hash['rendering_job']['rendering_manifest']['rendering_parameters']
      end
      
      it "should have a 'resolution' key" do
        @profile['resolution'].should == manifest.resolution
      end
      
      it "should have a 'framerate' key" do
        @profile['framerate'].should == manifest.framerate
      end
      
      it "should have a 'format' key" do
        @profile['format'].should == manifest.format
      end
    end
    
    describe "when an HTTP callback is set" do
      before do
        manifest.http_callback_url = "http://website.com/callback"
      end
      
      describe "but a format isn't" do
        it "should raise an error" do
          lambda { manifest.to_hash }.should raise_error(ArgumentError)
        end
      end
      
      describe "as well as the format" do
        before do
          manifest.http_callback_format = 'xml'
        end
        
        it "should have the HTTP callback URL in the job" do
          manifest.to_hash['rendering_job'].should have_key('http_callback')
          manifest.to_hash['rendering_job']['http_callback'].should == manifest.http_callback_url
        end
        
        it "should have the HTTP callback format in the job" do
          manifest.to_hash['rendering_job'].should have_key('http_callback_format')
          manifest.to_hash['rendering_job']['http_callback_format'].should == manifest.http_callback_format
        end
      end
    end
  end
end