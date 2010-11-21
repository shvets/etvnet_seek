source "http://rubygems.org"

gem "nokogiri"
gem "libxml-ruby"
gem "zipit"
gem "json_pure"

group :development do
  gem "jeweler"
  gem "gemcutter"
  gem "rake"
  gem "highline"

  gem 'ruby-debug-base19' if RUBY_VERSION.include? "1.9"
  gem 'ruby-debug-base' if RUBY_VERSION.include? "1.8"
  gem "ruby-debug-ide"  
end

group :test do
  gem "mocha"
  gem "rspec", "1.3.0", :require => "spec"
  gem "rcov"
end

