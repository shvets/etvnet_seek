# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{etvnet-seek}
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Shvets"]
  s.date = %q{2010-07-11}
  s.default_executable = %q{etvnet-seek}
  s.description = %q{Command line tool for getting mms urls from etvnet service.}
  s.email = %q{alexander.shvets@gmail.com}
  s.executables = ["etvnet-seek"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "CHANGES",
     "Gemfile",
     "README",
     "Rakefile",
     "VERSION",
     "bin/etvnet-seek",
     "bin/etvnet-seek.bat",
     "etvnet-seek.gemspec",
     "lib/etvnet_seek/commander.rb",
     "lib/etvnet_seek/cookie_helper.rb",
     "lib/etvnet_seek/core/access_page.rb",
     "lib/etvnet_seek/core/browse_media_item.rb",
     "lib/etvnet_seek/core/catalog_item.rb",
     "lib/etvnet_seek/core/catalog_page.rb",
     "lib/etvnet_seek/core/channel_media_item.rb",
     "lib/etvnet_seek/core/channels_page.rb",
     "lib/etvnet_seek/core/group_media_item.rb",
     "lib/etvnet_seek/core/group_page.rb",
     "lib/etvnet_seek/core/home_page.rb",
     "lib/etvnet_seek/core/login_page.rb",
     "lib/etvnet_seek/core/media_info.rb",
     "lib/etvnet_seek/core/media_item.rb",
     "lib/etvnet_seek/core/media_page.rb",
     "lib/etvnet_seek/core/new_item.rb",
     "lib/etvnet_seek/core/new_items_page.rb",
     "lib/etvnet_seek/core/page.rb",
     "lib/etvnet_seek/core/page_factory.rb",
     "lib/etvnet_seek/core/search_page.rb",
     "lib/etvnet_seek/core/service_call.rb",
     "lib/etvnet_seek/easy_auth.rb",
     "lib/etvnet_seek/etvnet_seek.rb",
     "lib/etvnet_seek/link_info.rb",
     "lib/etvnet_seek/main.rb",
     "lib/etvnet_seek/user_selection.rb",
     "lib/media_converter.rb",
     "lib/progressbar.rb",
     "lib/runglish.rb"
  ]
  s.homepage = %q{http://github.com/shvets/etvnet-seek}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Accessing etvnet service from command line.}
  s.test_files = [
    "spec/etvnet_seek_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 1.2.0"])
      s.add_runtime_dependency(%q<highline>, [">= 1.5.1"])
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 1.1.3"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.1"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.7"])
    else
      s.add_dependency(%q<json_pure>, [">= 1.2.0"])
      s.add_dependency(%q<highline>, [">= 1.5.1"])
      s.add_dependency(%q<libxml-ruby>, [">= 1.1.3"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.1"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<mocha>, [">= 0.9.7"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 1.2.0"])
    s.add_dependency(%q<highline>, [">= 1.5.1"])
    s.add_dependency(%q<libxml-ruby>, [">= 1.1.3"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.1"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<mocha>, [">= 0.9.7"])
  end
end
