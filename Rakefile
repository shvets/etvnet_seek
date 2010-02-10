begin
  require 'zip_it'
rescue LoadError
  puts "Zipit is not available. Install it with: sudo gem install zipit"
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
