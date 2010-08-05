require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Storyboard do
  def storyboard options = {}
    @storyboard ||= Animoto::Storyboard.new options
  end
  
end
