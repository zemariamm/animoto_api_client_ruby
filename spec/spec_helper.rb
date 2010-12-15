Bundler.setup(:default, :test)

require 'rspec'
require 'webmock/rspec'
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include WebMock::API
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/animoto/client')