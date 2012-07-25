# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cocoadex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{A command-line class reference utility Cocoa APIs}
  gem.summary       = %q{A command-line class reference utility for Cocoa APIs, based on RI.}
  gem.homepage      = "http://kattrali.github.com/cocoadex"

  gem.name          = "cocoadex"
  gem.require_paths = ["lib"]
  gem.extra_rdoc_files = ['readme.md','changelog.md']
  gem.version       = Cocoadex::VERSION
  # gem.add_development_dependency('bacon')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_dependency('methadone', '~>1.2.1')
  gem.add_dependency('term-ansicolor')
  # gem.add_dependency('sqlite3')
  gem.add_dependency('bri')
  gem.add_dependency('nokogiri')
  gem.files = %W{
    Gemfile
    LICENSE
    LICENSE.txt
    changelog.md
    readme.md
    bin/cocoadex
    bin/cdex_completion
    lib/cocoadex.rb
    lib/cocoadex/docset_helper.rb
    lib/cocoadex/keyword.rb
    lib/cocoadex/parser.rb
    lib/cocoadex/serializer.rb
    lib/cocoadex/templates.rb
    lib/cocoadex/version.rb
    lib/cocoadex/models/class.rb
    lib/cocoadex/models/docset.rb
    lib/cocoadex/models/element.rb
    lib/cocoadex/models/entity.rb
    lib/cocoadex/models/method.rb
    lib/cocoadex/models/property.rb
    lib/cocoadex/tools/completion_helper.rb
    lib/ext/nil.rb
    tools/bash_completion.sh
    tools/zsh_completion.sh
  }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
