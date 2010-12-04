require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'rake'
require 'rspec/core/rake_task'

begin
  require 'zipit'
rescue LoadError
  puts "Zipit is not available. Install it with: sudo gem install zipit"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "etvnet-seek"
    gemspec.summary = "Accessing etvnet service from command line."
    gemspec.description = "Command line tool for getting mms urls from etvnet service."
    gemspec.email = "alexander.shvets@gmail.com"
    gemspec.homepage = "http://github.com/shvets/etvnet-seek"
    gemspec.authors = ["Alexander Shvets"]
    gemspec.files = FileList["CHANGES", "etvnet-seek.gemspec", "Rakefile",  "Gemfile", "README", "VERSION", "lib/**/*", "bin/**"]
    gemspec.add_dependency("json_pure", ">= 1.2.0")
    gemspec.add_dependency("highline", ">= 1.5.1")
    gemspec.add_dependency("libxml-ruby", ">= 1.1.3")
    gemspec.add_dependency("nokogiri", ">= 1.4.1")

    gemspec.add_development_dependency "rspec", ">= 1.2.9"
    gemspec.add_development_dependency "mocha", ">= 0.9.7"

    gemspec.executables = ['etvnet-seek']
    gemspec.requirements = ["none"]
    gemspec.bindir = "bin"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalsteaks-jeweler -s http://gems.github.com"
end

task :zip do
  zip :archive => "etvnet-seek.zip", :dir => "."
end

desc "Release the gem"
task :"release:gem" do
  %x(
      rm -rf pkg
      rake gemspec
      rake build
      rake install
      git add .
  )
  puts "Commit message:"
  message = STDIN.gets

  version = "#{File.open(File::dirname(__FILE__) + "/VERSION").readlines().first}"

  %x(
    git commit -m "#{message}"

    git push origin master

    gem push pkg/google-translate-#{version}.gem
  )
end

desc "Run gem code locally"
task :"run:gem" do
  command = "bin/etvnet-seek"
  puts ruby("#{command}")
end

# configure rspec
RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.verbose = false
end

task :default => :zip



