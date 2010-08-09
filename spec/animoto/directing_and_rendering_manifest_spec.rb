require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Animoto::DirectingAndRenderingManifest do
  
  def manifest options = {}
    @manifest ||= Animoto::DirectingAndRenderingManifest.new options
  end
  
  describe "generating a hash" do
    before do
      manifest(:title => 'Funderful Wonderment', :producer => 'Senor Spielbergo', :pacing => 'double',
        :resolution => "720p", :framerate => 24, :format => 'flv')
      @image = manifest.add_image 'http://website.com/image.png'
      @title_card = manifest.add_title_card 'woohoo', 'this is awesome'
      @footage = manifest.add_footage 'http://website.com/movie.mp4'
      @song_obj = manifest.add_song 'http://website.com/song.mp3'
    end
    
    it "should have top-level 'directing_and_rendering_job' object" do
      manifest.to_hash.should have_key('directing_and_rendering_job')
      manifest.to_hash['directing_and_rendering_job'].should be_a(Hash)
    end

    describe "when the callback url is set" do
      before do
        manifest.http_callback_url = 'http://website.com/callback'        
      end

      describe "but the callback format isn't" do
        it "should raise an error" do
          lambda { manifest.to_hash }.should raise_error(ArgumentError)
        end
      end
  
      describe "as well as the format" do
        before do
          manifest.http_callback_format = 'xml'
        end
    
        it "should have the HTTP callback URL in the job" do
          manifest.to_hash['directing_and_rendering_job'].should have_key('http_callback')
          manifest.to_hash['directing_and_rendering_job']['http_callback'].should == manifest.http_callback_url
        end

        it "should have the HTTP callback format in the job" do
          manifest.to_hash['directing_and_rendering_job'].should have_key('http_callback_format')
          manifest.to_hash['directing_and_rendering_job']['http_callback_format'].should == manifest.http_callback_format
        end
      end
    end
    
    it "should have a 'directing_manifest' object within the job" do
      manifest.to_hash['directing_and_rendering_job'].should have_key('directing_manifest')
      manifest.to_hash['directing_and_rendering_job']['directing_manifest'].should be_a(Hash)
    end
    
    describe "directing_manifest" do
      before do
        @hash = manifest.to_hash['directing_and_rendering_job']['directing_manifest']
      end
      
      it "should have a 'style' key in the manifest" do
        @hash.should have_key('style')
        @hash['style'].should == manifest.style
      end
    
      it "should have a 'pacing' key in the manifest" do
        @hash.should have_key('pacing')
        @hash['pacing'].should == manifest.pacing
      end
    
      it "should have a 'producer_name' key in the manifest" do
        @hash.should have_key('producer_name')
        @hash['producer_name'].should == manifest.producer
      end
    
      it "should have a 'visuals' key in the manifest" do
        @hash.should have_key('visuals')
      end
    
      it "should have a 'song' object in the manifest" do
        @hash.should have_key('song')
        @hash['song'].should be_a(Hash)
      end
    
      describe "visuals array" do
        before do
          @visuals = @hash['visuals']
        end
      
        it "should have the visuals in the order they were added" do
          @visuals[0].should == @image.to_hash
          @visuals[1].should == @title_card.to_hash
          @visuals[2].should == @footage.to_hash
        end
      end
    
      describe "song" do
        before do
          @song = @hash['song']
        end
      
        it "should have info about the song" do
          @song.should == @song_obj.to_hash
        end
      end
    end

    it "should have a 'rendering_manifest' object within the job" do
      manifest.to_hash['directing_and_rendering_job'].should have_key('rendering_manifest')
      manifest.to_hash['directing_and_rendering_job']['rendering_manifest'].should be_a(Hash)
    end

    describe "rendering_manifest" do
      before do
        @hash = manifest.to_hash['directing_and_rendering_job']['rendering_manifest']
      end
      
      it "should have a 'rendering_profile' object in the manifest" do
        @hash.should have_key('rendering_profile')
        @hash['rendering_profile'].should be_a(Hash)
      end

      describe "rendering_profile" do
        before do
          @profile = @hash['rendering_profile']
        end

        it "should have a 'vertical_resolution' key" do
          @profile['vertical_resolution'].should == manifest.resolution
        end

        it "should have a 'framerate' key" do
          @profile['framerate'].should == manifest.framerate
        end

        it "should have a 'format' key" do
          @profile['format'].should == manifest.format
        end
      end
    end
  end  
end