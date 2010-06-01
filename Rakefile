require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'rake'
require 'spec/rake/spectask'

begin
  require 'zipit'
rescue LoadError
  puts "Zipit is not available. Install it with: sudo gem install zipit"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "etvnet_seek"
    gemspec.summary = "Accessing etvnet service from command line."
    gemspec.description = "Command line tool for getting mms urls from etvnet service."
    gemspec.email = "alexander.shvets@gmail.com"
    gemspec.homepage = "http://github.com/shvets/etvnet_seek"
    gemspec.authors = ["Alexander Shvets"]
    gemspec.files = FileList["CHANGES", "etvnet_seek.gemspec", "Rakefile", "README", "VERSION", "lib/**/*", "bin/**"]
    gemspec.add_dependency("json_pure", ">= 1.2.0")
    gemspec.add_dependency("highline", ">= 1.5.1")
    gemspec.add_dependency("libxml-ruby", ">= 1.1.3")
    gemspec.add_dependency("nokogiri", ">= 1.4.1")

    gemspec.add_development_dependency "rspec", ">= 1.2.9"
    gemspec.add_development_dependency "mocha", ">= 0.9.7"

    gemspec.executables = ['etvnet_seek']
    gemspec.requirements = ["none"]
    gemspec.bindir = "bin"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalsteaks-jeweler -s http://gems.github.com"
end

task :zip do
  zip :archive => "etvnet_seek.zip", :dir => "."
end

desc "Run gem code locally"
task :"run:gem" do
  command = "bin/etvnet_seek"
  puts ruby("#{command}")
end

# configure rspec
Spec::Rake::SpecTask.new do |spec|
 spec.spec_files = FileList["spec/**/*_spec.rb"]
 spec.spec_opts << "--color"
 spec.libs += ["lib", "spec"]
end

task :default => :zip



