# -*- encoding: utf-8 -*-                 

Gem::Specification.new do |s|
  s.name = %q{app_store}
  s.version = "0.1.3"
  s.platform = Gem::Platform::RUBY
  s.homepage = %q{https://github.com/jakimowicz/app_store}
  s.authors = ["Fabien Jakimowicz"]
  s.email = ["fabien@jakimowicz.com"]
  s.description = %q{AppStore is an unofficial implementation of the Apple AppStore API. It provides way to search for applications, navigate through categories.}
  s.summary = %q{AppStore is an unofficial implementation of the Apple AppStore API. It provides way to search for applications, navigate through categories.}

  s.files = `git ls-files`.split("\n").sort
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("mechanize", ">= 0") 
  s.add_dependency("nokogiri", ">= 0") 
  s.add_dependency("plist", ">= 0") 
end