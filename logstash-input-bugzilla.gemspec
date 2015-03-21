# The Specification class contains the information for a Gem. Typically defined in a .gemspec file or a Rakefile
# Starting in RubyGems 2.0, a Specification can hold arbitrary metadata. See metadata for restrictions on the format and size of metadata items you may add to a specification.
# http://guides.rubygems.org/specification-reference

Gem::Specification.new do |s|
  s.name = 'logstash-input-bugzilla'
  s.version = '0.0.1.pre'
  s.licenses = ['GPLv2']
  s.summary = "This input streams from Bugzilla at a definable interval."
  s.description = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["Alexander Braverman Masis", "Liron Greenberg"]
  s.email = 'alexbmasis@gmail.com'
  s.require_paths = ["lib"]
  # Files
  s.files = `git ls-files`.split($\)
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }
  # Gem dependencies
  s.add_runtime_dependency "logstash-core", '>= 1.4.0', '< 2.0.0'
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud'
  s.add_development_dependency 'logstash-devutils'
end