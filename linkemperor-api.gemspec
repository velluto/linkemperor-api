# -*- encoding: utf-8 -*-
require File.expand_path('../lib/linkemperor-api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["LinkEmperor"]
  gem.email         = ["linkemperor@linkemperor.com"]
  gem.description   = %q{Link Emperor API for Customers and Vendors}
  gem.summary       = %q{Link Emperor API}
  gem.homepage      = "http://www.linkemperor.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "linkemperor-api"
  gem.require_paths = ["lib"]
  gem.version       = Linkemperor::Api::VERSION
end
