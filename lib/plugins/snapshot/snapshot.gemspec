# -*- encoding: utf-8 -*-
require File.expand_path('../lib/snapshot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["麦飞"]
  gem.email         = ["kehao.qiu@gmail.com"]
  gem.description   = %q{web snapshot}
  gem.summary       = %q{web snapshot}
  gem.homepage      = ""

  gem.add_dependency 'activerecord', '~> 3.0'
  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'rspec', '~> 2.8.0'
  gem.add_development_dependency 'factory_girl_rails'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "snapshot"
  gem.require_paths = ["lib"]
  gem.version       = Snapshot::VERSION
end
