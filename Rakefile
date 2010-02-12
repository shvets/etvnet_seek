begin
  require 'zip_it'
rescue LoadError
  puts "Zipit is not available. Install it with: sudo gem install zipit"
  exit
end


begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    #define which metrics you want to use
    config.metrics  = [:churn, :saikuro, :flog, :flay, :reek, :roodi, :rcov]
    config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
    config.flay     = { :dirs_to_flay => ['app', 'lib'],
                        :minimum_score => 100  }
    config.flog     = { :dirs_to_flog => ['app', 'lib']  }
    config.reek     = { :dirs_to_reek => ['app', 'lib']  }
    config.roodi    = { :dirs_to_roodi => ['app', 'lib'] }
    config.saikuro  = { :output_directory => 'scratch_directory/saikuro',
                        :input_directory => ['app', 'lib'],
                        :cyclo => "",
                        :filter_cyclo => "0",
                        :warn_cyclo => "5",
                        :error_cyclo => "7",
                        :formater => "text"} #this needs to be set to "text"
    config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
    config.rcov     = { :environment => 'test',
                        :test_files => ['test/**/*_test.rb',
                                        'spec/**/*_spec.rb'],
                        :rcov_opts => ["--sort coverage",
                                       "--no-html",
                                       "--text-coverage",
                                       "--no-color",
                                       "--profile",
                                       "--rails",
                                       "--exclude /gems/,/Library/,spec"]}
    config.graph_engine = :bluff
  end
rescue LoadError
  puts "MetricFu is not available. Install it with: sudo gem install metric_fu"
  exit
end

task :zip do
  zip :archive => "etvnet_seek.zip", :dir => "."
end

desc "Run gem code locally"
task :"run:gem" do
  command = "bin/etvnet_seek $1 $2"
  puts ruby("#{command}")
end

# configure rspec
#Spec::Rake::SpecTask.new do |spec|
#  spec.spec_files = FileList["spec/**/*_spec.rb"]
#  spec.spec_opts << "--color"
#  spec.libs += ["lib", "spec"]
#end

task :default => :zip
