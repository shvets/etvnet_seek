require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'logger'

LOGGER = Logger.new(STDOUT)

gems = {
  'rake' => '0.8.7',
  'rspec' => '1.2.9',
  'mocha' => '0.9.7',

  'json_pure' => '1.2.0',
  'highline' => '1.5.1',
  'libxml-ruby' => '1.1.3', # nokogiri needs a new version of libxml
  'nokogiri' => '1.4.1'
}

def info(message)
  LOGGER.info message
end

gems.each do |k, v|
  info "checking availability of #{k} in version #{v}"
  if Gem.cache.find_name(k, "=#{v}").empty?
    info "gem not found, installing #{k} #{v}"
    info `gem install -v=#{v} #{k}`
  end
end