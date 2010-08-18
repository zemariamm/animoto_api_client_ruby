require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::ResponseParser::JSONAdapter do
  
  before do
    @parser = Animoto::ResponseParser::JSONAdapter.new
  end
  
  it "should be JSON format" do
    @parser.format.should == 'json'
  end
  
  describe "parsing" do
    before do
      @json = %Q!{"hash":{"number":1,"float":1.9,"array":["hooray","for","dolphins"],"string":"woohoo"}}!
      @hash = @parser.parse(@json)
    end
    
    it "should return a hash" do
      @hash.should be_an_instance_of(Hash)
    end
    
    it "should turn the object root into a hash" do
      @hash.should have_key('hash')
    end
    
    it "should turn array elements into an array" do
      @hash['hash'].should have_key('array')
      @hash['hash']['array'].should be_an_instance_of(Array)
    end
    
    it "should preserve the order of elements in an array" do
      @hash['hash']['array'].should == ["hooray", "for", "dolphins"]
    end
    
    it "should turn each object attribute into a key/value pair in the hash" do
      @hash['hash'].should have_key('number')
      @hash['hash']['number'].should be_an_instance_of(Fixnum)
    end
    
    it "should turn attributes with strictly numeric values into integers" do
      @hash['hash']['number'].should eql(1)
    end
    
    it "should turn attributes with content representing floats into floats" do
      @hash['hash']['float'].should eql(1.9)
    end
    
    it "should turn strings into strings" do
      @hash['hash']['string'].should be_an_instance_of(String)
      @hash['hash']['string'].should == "woohoo"
    end
  end
  
  describe "unparsing" do
    before do
      @obj = {
        'hash' => {
          'array'   => [ 'hooray', 'for', 'dolphins' ],
          'string'  => 'woohoo',
          'number'  => 1
        }
      }
      @json_str = @parser.unparse(@obj)
      @json = ::JSON.parse(@json_str)
    end
    
    it "should turn hashes into objects with attributes" do
      @json.should have_key('hash')
      @json['hash'].should_not be_empty
    end
    
    it "should turn arrays into arrays" do
      @json['hash'].should have_key('array')
      @json['hash']['array'].should be_an_instance_of(Array)
    end
    
    it "should turn strings into text content" do
      @json['hash'].should have_key('string')
      @json['hash']['string'].should == "woohoo"
    end
    
    it "should turn numbers into text content" do
      @json_str.should =~ /"number"\s*:\s*1/
    end
  end
  
end