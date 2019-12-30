# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'farsifu/version'

Gem::Specification.new do |s|
  s.name                      = 'farsifu'
  s.version                   = FarsiFu::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ['Allen A. Bargi', 'Arash Mousavi']
  s.email                     = 'allen.bargi@gmail.com mousavi.arash@gmail.com'
  s.homepage                  = 'http://github.com/aziz/farsifu'
  s.summary                   = 'a toolbox for developing ruby applications in Persian (Farsi) language, see readme file for features'
  s.description               = 'a toolbox for developing ruby applications in Persian (Farsi) language, see readme file for features'
  s.license                   = 'MIT'
  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables               = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths             = ['lib']
  s.extra_rdoc_files          = ['LICENSE', 'README.md']
  s.rdoc_options              = ['--charset=UTF-8']
  s.add_development_dependency 'rspec', '~> 3.9'
end
