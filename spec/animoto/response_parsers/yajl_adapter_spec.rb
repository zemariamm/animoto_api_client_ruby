require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::ResponseParsers::YajlAdapter do
  
  before do
    @parser = Animoto::ResponseParsers::YajlAdapter.new
  end
  
  it "should be JSON format" do
    @parser.format.should == 'json'
  end
  
  describe "parsing" do
    before do
      @json = %Q!{"result":{"rank":1,"score":1.9,"tags":["hooray","for","dolphins"],"message":"woohoo"}}!
      @hash = @parser.parse(@json)
    end
    
    it "should return a hash" do
      @hash.should be_an_instance_of(Hash)
    end
    
    it "should turn the object root into a hash" do
      @hash.should have_key('result')
    end
    
    it "should turn array elements into an array" do
      @hash['result'].should have_key('tags')
      @hash['result']['tags'].should be_an_instance_of(Array)
    end
    
    it "should preserve the order of elements in an array" do
      @hash['result']['tags'].should == ["hooray", "for", "dolphins"]
    end
    
    it "should turn each object attribute into a key/value pair in the hash" do
      @hash['result'].should have_key('rank')
      @hash['result']['rank'].should be_an_instance_of(Fixnum)
    end
    
    it "should turn attributes with strictly numeric values into integers" do
      @hash['result']['rank'].should eql(1)
    end
    
    it "should turn attributes with content representing floats into floats" do
      @hash['result']['score'].should eql(1.9)
    end
    
    it "should turn strings into strings" do
      @hash['result']['message'].should be_an_instance_of(String)
      @hash['result']['message'].should == "woohoo"
    end
  end
  
  describe "unparsing" do
    before do
      @obj = {
        'result' => {
          'tags'    => [ 'hooray', 'for', 'dolphins' ],
          'message' => 'woohoo',
          'rank'    => 1,
          'score'   => 1.9
        }
      }
      @json_str = @parser.unparse(@obj)
      @json = ::JSON.parse(@json_str)
    end
    
    it "should turn hashes into objects with attributes" do
      @json.should have_key('result')
      @json['result'].should_not be_empty
    end
    
    it "should turn arrays into arrays" do
      @json['result'].should have_key('tags')
      @json['result']['tags'].should be_an_instance_of(Array)
    end
    
    it "should turn strings into text content" do
      @json['result'].should have_key('message')
      @json['result']['message'].should == "woohoo"
    end
    
    it "should turn integers into integers" do
      @json_str.should =~ /"rank"\s*:\s*1/
    end
    
    it "should turn floats into floats" do
      @json_str.should =~ /"score"\s*:\s*1\.9/
    end
  end
  
end