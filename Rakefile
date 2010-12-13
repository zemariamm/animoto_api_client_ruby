require 'spec/rake/spectask'

task 'default' => 'test:spec'

namespace :test do
  desc "Run tests"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
end

