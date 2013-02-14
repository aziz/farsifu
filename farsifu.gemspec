# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "farsifu/version"

Gem::Specification.new do |s|
  s.name                      = "farsifu"
  s.version                   = FarsiFu::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Allen A. Bargi", "Arash Mousavi"]
  s.email                     = %q{allen.bargi@gmail.com mousavi.arash@gmail.com}
  s.homepage                  = %q{http://github.com/aziz/farsifu}
  s.summary                   = %q{a toolbox for developing ruby applications in Persian (Farsi) language, see readme file for features}
  s.description               = %q{a toolbox for developing ruby applications in Persian (Farsi) language, see readme file for features}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubyforge_project         = "farsifu"
  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables               = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths             = ["lib"]
  s.extra_rdoc_files          = [ "LICENSE", "README.md"]
  s.rdoc_options              = ["--charset=UTF-8"]
  s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
  s.add_development_dependency(%q<bundler>, ["~> 1.2.0"])
  s.add_development_dependency(%q<guard-rspec>)
end
