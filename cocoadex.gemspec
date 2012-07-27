# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cocoadex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{CLI for Cocoa documentation reference}
  gem.summary       = %q{A command-line class reference utility for Cocoa APIs, inspired by RI.}
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
  gem.add_dependency('ruby-progressbar')
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
    lib/cocoadex/version.rb
    lib/cocoadex/model
    lib/cocoadex/models/callback.rb
    lib/cocoadex/models/class.rb
    lib/cocoadex/models/constant.rb
    lib/cocoadex/models/data_type.rb
    lib/cocoadex/models/docset.rb
    lib/cocoadex/models/element.rb
    lib/cocoadex/models/entity.rb
    lib/cocoadex/models/function.rb
    lib/cocoadex/models/generic_ref.rb
    lib/cocoadex/models/method.rb
    lib/cocoadex/models/nested_node_element.rb
    lib/cocoadex/models/parameter.rb
    lib/cocoadex/models/property.rb
    lib/cocoadex/models/result_code.rb
    lib/cocoadex/models/seq_node_element.rb
    lib/ext/xml_element.rb
    lib/ext/nil.rb
    lib/ext/string.rb
    lib/ext/template_helpers.rb
    views/callback.erb
    views/class.erb
    views/constant.erb
    views/constant_group.erb
    views/data_type.erb
    views/function.erb
    views/generic_ref.erb
    views/method.erb
    views/multiple.erb
    views/property.erb
    views/result_code.erb
  }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
