require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Animoto::Project do

  def project options = {}
    @project ||= Animoto::Project.new options
  end
  
end