require 'spec'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require File.dirname(__FILE__) + '/../lib/animoto/client'