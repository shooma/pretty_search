# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "pretty_search"
  gem.version       = '0.1.6'
  gem.add_runtime_dependency 'kaminari', ['>= 0.14']
  gem.add_runtime_dependency 'rails', ['~> 3']
  gem.add_runtime_dependency 'haml', ['>= 0']
  gem.authors       = ["shooma", "waxerdima"]
  gem.email         = ["neshooma@mail.ru", "shooma@mishkov@gmail.com"]
  gem.description   = %q{blank yet}
  gem.summary       = %q{Штука, позволяющая искать записи по ассоциированным моделям прямо в форме}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "app"]
end
