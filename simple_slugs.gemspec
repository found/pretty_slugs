# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pretty_slugs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Hopkins", "Timothy Johnson"]
  gem.email         = ["kevin@h-pk-ns.com", "timothy@wearefound.com"]
  gem.description   = %q{Pretty Slugs for Rails models}
  gem.summary       = %q{Pretty Slugs stores sluggified strings for rails models in an extensible way}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pretty_slugs"
  gem.require_paths = ["lib"]
  gem.version       = PrettySlugs::VERSION
end
