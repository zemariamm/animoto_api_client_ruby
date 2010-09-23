require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Resources::Storyboard do
  def storyboard options = {}
    @storyboard ||= Animoto::Resources::Storyboard.new options
  end
  
end
