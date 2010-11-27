require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'etvnet_seek/main'

