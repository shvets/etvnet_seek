# -*- encoding: utf-8 -*-

require "rake"

Gem::Specification.new do |s|
  s.name = %q{etvnet_seek}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
 
  s.authors = ["Alexander Shvets"]
  s.date = %q{2010-02-06}
  s.description = %q{Command line tool for getting mms urls from etvnet service.}
  s.email = %q{alexander.shvets@gmail.com}

  s.files = FileList["bin/**", "lib/**/*.rb", "spec/**", "CHANGES", "etvnet_seek.gemspec", "Rakefile", "README"]
  s.test_files = FileList["spec/**/*.rb"]
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/shvets/etvnet_seek}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{etvnet_seek}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Command line tool for getting mms urls from etvnet service.}

  if s.respond_to? :specification_version then
    s.specification_version = 2
  end

  s.platform = Gem::Platform::RUBY
  s.requirements = ["none"]
  s.executables = ['etvnet_seek']
  s.bindir = "bin"

  s.add_dependency("json_pure", ">= 1.2.0")
  s.add_dependency("highline", ">= 1.5.1")
  s.add_dependency("nokogiri", ">= 1.3.3")

  s.add_development_dependency "rspec", ">= 1.2.8"
  s.add_development_dependency "mocha", ">= 0.9.7"  
end
