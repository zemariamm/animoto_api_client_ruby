require 'nokogiri'
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::ResponseParser::REXMLAdapter do
  
  before do
    @parser = Animoto::ResponseParser::REXMLAdapter.new
  end
  
  it "should be XML format" do
    @parser.format.should == 'xml'
  end
  
  describe "parsing" do
    before do
      @xml = %Q{<?xml version="1.0"?><hash><number>1</number><float>1.9</float><array>hooray</array><array>for</array><array>dolphins</array><string>woohoo</string></hash>}
      @hash = @parser.parse(@xml)
    end
    
    it "should return a hash" do
      @hash.should be_an_instance_of(Hash)
    end
    
    it "should turn the document root into a hash" do
      @hash.should have_key('hash')
    end
    
    it "should turn repeated elements into an array" do
      @hash['hash'].should have_key('array')
      @hash['hash']['array'].should be_an_instance_of(Array)
    end
    
    it "should preserve the order of repeated elements in an array" do
      @hash['hash']['array'].should == ["hooray", "for", "dolphins"]
    end
    
    it "should turn an element with only text children into a key/value pair in the hash" do
      @hash['hash'].should have_key('number')
      @hash['hash']['number'].should be_an_instance_of(Fixnum)
    end
    
    it "should turn elements with strictly numeric content into integers" do
      @hash['hash']['number'].should eql(1)
    end
    
    it "should turn elements with content representing floats into floats" do
      @hash['hash']['float'].should eql(1.9)
    end
    
    it "should turn elements with general textual content into strings" do
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
      @xml_str = @parser.unparse(@obj)
      @xml = ::Nokogiri::XML(@xml_str)
    end
    
    it "should turn hashes into tags with nested elements" do
      @xml.at('/hash').should_not be_nil
      @xml.at('/hash').children.should_not be_empty
    end
    
    it "should turn arrays into multiple elements with the same name" do
      @xml.search('/hash/*[name()="array"]').size.should == 3
    end
    
    it "should turn strings into text content" do
      @xml.at('/hash/string/text()').to_s.should == "woohoo"
    end
    
    it "should turn numbers into text content" do
      @xml.at('/hash/number/text()').to_s.should == "1"
    end
  end
  
end