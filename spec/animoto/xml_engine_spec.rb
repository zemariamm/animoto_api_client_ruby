require "rexml/document"

require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::XMLEngine do
  before do
    @engine = Animoto::XMLEngine.new
  end
  
  describe "converting a Hash to XML" do
    before do
      @hash = { :hash => {
          :foo => "abc",
          :bar => [ "def", "ghi", "jkl" ],
          :baz => { :quux => "mno" }
        }
      }
      @xml = @engine.dump(@hash)
      @rex = REXML::Document.new(@xml)
    end
    
  end
  
  describe "converting XML to a Hash" do
    before do
      @xml = '<hash><foo>abc</foo><bar>def</bar><bar>ghi</bar><bar>jkl</bar><baz><quux>mno</quux></baz></hash>'
      @hash = @engine.load(@xml)
    end
    
    
  end
end