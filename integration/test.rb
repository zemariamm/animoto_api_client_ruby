require 'rubygems'
require 'rdiscount'
require 'nokogiri'
require 'yaml'

puts "Reading in code from README.md"

readme_path = File.dirname(__FILE__) + '/../README.md'
begin
  readme = RDiscount.new(File.read(readme_path))
rescue Errno::ENOENT
  raise "README.md not found in #{File.expand_path(readme_path)}!"
end

begin
  credentials = YAML.load(File.read(File.dirname(__FILE__) + '/credentials.yml'))
rescue Errno::ENOENT
  raise "Credentials file not found at #{File.expand_path(File.dirname(__FILE__) + '/credentials.yml')}!"
end

begin
  assets = YAML.load(File.read(File.dirname(__FILE__) + '/assets.yml'))
rescue Errno::ENOENT
  raise "Assets file not found in at #{File.dirname(__FILE__) + '/assets.yml'}!" unless assets
end

doc = Nokogiri::HTML(readme.to_html)
example_code_path = '//h3[contains(text(),"basic example")]/following-sibling::pre/code/text()'
code_node = doc.at(example_code_path)

raise "Example code not found in README (expected at xpath '#{example_code_path}')" unless code_node

code = code_node.text

puts "Replacing example credentials with valid ones"
code.sub!(/Client\.new\(.+\)/, %Q{Client.new("#{credentials[:key]}","#{credentials[:secret]}")})

puts "Replacing example assets with valid ones"
code.gsub!(/Image\.new\(.+\)/) { %Q{Image.new("#{assets[:images].shift}")} }
# Replace the song with a real one
code.sub!(/Song\.new\(.+\)/, %Q{Song.new("#{assets[:song]}")})
# Get rid of the footage (since it won't render right now anyway)
code = code.lines.reject { |l| /Footage\.new/ === l }.join

puts "Executing example"
eval code

puts
puts "If you're seeing this, things should have worked fine!"
puts "Enjoy your video at #{video.download_url}"