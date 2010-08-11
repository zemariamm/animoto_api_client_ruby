require File.dirname(__FILE__) + '/lib/animoto'

Gem::Specification.new do |s|
  s.name = "animoto"
  s.version = Animoto.version
  s.author = "Animoto"
  s.email = "theteam@animoto.com"
  s.files = Dir.glob("./**/*.rb")
  s.has_rdoc = true
  s.require_paths = ["lib"]
  s.homepage = "http://animoto.com"
  s.summary = ""
  s.description = ""
  s.add_runtime_dependency "json", ["> 0.0.0"]
end