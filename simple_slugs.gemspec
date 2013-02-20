# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_slugs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Hopkins"]
  gem.email         = ["kevin@h-pk-ns.com"]
  gem.description   = %q{Simple Slugs for Rails models}
  gem.summary       = %q{Simple Slugs stores sluggified strings for rails models in an extensible way}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple_slugs"
  gem.require_paths = ["lib"]
  gem.version       = SimpleSlugs::VERSION
end
