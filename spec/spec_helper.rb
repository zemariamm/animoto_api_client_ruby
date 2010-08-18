require 'spec'
require 'webmock/rspec'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include WebMock
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/animoto/client')