require 'rspec/core/rake_task'

task 'default' => 'test:spec'

namespace :test do
  desc "Run tests"
  RSpec::Core::RakeTask.new('spec') do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
end

