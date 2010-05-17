require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

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
    gemspec.add_development_dependency "metric_fu"
    gemspec.add_development_dependency "reek"
    gemspec.add_development_dependency "roodi"
    gemspec.add_development_dependency "googlecharts"

    gemspec.executables = ['etvnet_seek']
    gemspec.requirements = ["none"]
    gemspec.bindir = "bin"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalsteaks-jeweler -s http://gems.github.com"
end

#begin
#  require 'metric_fu'
#
#  MetricFu::Configuration.run do |config|
#    #define which metrics you want to use
#    config.metrics  = [:churn, :saikuro, :flog, :flay, :reek, :roodi, :rcov]
#    config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
#    config.flay     = {:dirs_to_flay => ['app', 'lib'],
#      :minimum_score => 100}
#    config.flog     = {:dirs_to_flog => ['app', 'lib']}
#    config.reek     = {:dirs_to_reek => ['app', 'lib']}
#    config.roodi    = {:dirs_to_roodi => ['app', 'lib']}
#    config.saikuro  = {:output_directory => 'scratch_directory/saikuro',
#      :input_directory => ['app', 'lib'],
#      :cyclo => "",
#      :filter_cyclo => "0",
#      :warn_cyclo => "5",
#      :error_cyclo => "7",
#      :formater => "text"} #this needs to be set to "text"
#    config.churn    = {:start_date => "1 year ago", :minimum_churn_count => 10}
#    config.rcov     = {:environment => 'test',
#      :test_files => ['test/**/*_test.rb',
#        'spec/**/*_spec.rb'],
#      :rcov_opts => ["--sort coverage",
#        "--no-html",
#        "--text-coverage",
#        "--no-color",
#        "--profile",
#        "--rails",
#        "--exclude /gems/,/Library/,spec"]}
#    config.graph_engine = :bluff
#  end
#rescue LoadError
#  puts "MetricFu is not available. Install it with: sudo gem install metric_fu"
#  #exit
#end

task :zip do
  zip :archive => "etvnet_seek.zip", :dir => "."
end

desc "Run gem code locally"
task :"run:gem" do
  command = "bin/etvnet_seek"
  puts ruby("#{command}")
end

# configure rspec
#Spec::Rake::SpecTask.new do |spec|
#  spec.spec_files = FileList["spec/**/*_spec.rb"]
#  spec.spec_opts << "--color"
#  spec.libs += ["lib", "spec"]
#end

task :default => :zip


