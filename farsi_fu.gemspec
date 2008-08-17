require 'rubygems'

spec = Gem::Specification.new do |s|
	s.name = "FarsiFu"
	s.version = "0.1.0"
	s.author = "Aziz Ashofte Bargi"
	s.email = "aziz.bargi@gmail.com"
	s.rubyforge_project = 'FarsiFu'	
	s.homepage = "http://farsifu.rubyforge.org"
	s.summary = "A library for converting numbers to Persian digits and spelling numbers in Persian"
	s.platform = Gem::Platform::RUBY
	s.files = ["lib/farsi_fu.rb", "test/test.rb"]
	s.require_path = "lib"
	s.test_file = "test/test.rb"
	s.has_rdoc = true
	s.extra_rdoc_files = ["README","CHANGELOG","TODO","MIT-LICENSE"]
end

if $0 == __FILE__
	Gem::manage_gems
	Gem::Builder.new(spec).build
end