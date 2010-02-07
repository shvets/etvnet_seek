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

task :default => :zip
