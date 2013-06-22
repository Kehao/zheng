# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sqider/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kame", "calebx"]
  gem.email         = ["chenhb2@qqw.com.cn", "xiangkh@qqw.com.cn"]
  gem.description   = %q{A simple spider to fetch data from 3rd party website for internal using.}
  gem.summary       = %q{A simple spider to fetch data from 3rd party website for internal using.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sqider"
  gem.require_paths = ["lib"]
  gem.version       = Sqider::VERSION

  gem.add_dependency('nokogiri', '~> 1.5.2')
  gem.add_dependency('httparty', '~> 0.8.3')
  gem.add_dependency('json', '~> 1.7.3')
end
