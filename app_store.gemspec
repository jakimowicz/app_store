# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{app_store}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  
  s.authors = ["Fabien Jakimowicz"]                          
  s.date = %q{2011-09-22}
  s.description = %q{AppStore is an unofficial implementation of the Apple AppStore API. It provides way to search for applications, navigate through categories.}
  s.email = %q{fabien@jakimowicz.com}   
  
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/app_store.rb",
    "lib/app_store/helpers/plist.rb",
    "lib/app_store/helpers/proxy.rb",
    "lib/app_store/helpers/string.rb",
    "lib/app_store/agent.rb",
    "lib/app_store/application.rb",
    "lib/app_store/artwork.rb",
    "lib/app_store/category.rb",
    "lib/app_store/client.rb",
    "lib/app_store/company.rb",
    "lib/app_store/helper.rb",
    "lib/app_store/image.rb",
    "lib/app_store/link.rb",
    "lib/app_store/list.rb",
    "lib/app_store/user_review.rb"    
  ]
  
  s.homepage = %q{https://github.com/tandam/app_store}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{AppStore is an unofficial implementation of the Apple AppStore API. It provides way to search for applications, navigate through categories.}
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end