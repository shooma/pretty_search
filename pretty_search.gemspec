# encoding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "pretty_search"
  gem.version       = '0.1.46'

  gem.add_runtime_dependency 'kaminari', ['>= 0.14']
  gem.add_runtime_dependency 'rails', ['~> 3']
  #gem.add_runtime_dependency 'haml', ['>= 0']

  gem.add_development_dependency 'rspec-rails', '~> 2.13'
  gem.add_development_dependency 'shoulda-matchers', '~> 1.5.2'
  gem.add_development_dependency 'factory_girl_rails'
  gem.add_development_dependency 'activerecord-postgresql-adapter'
  gem.add_development_dependency 'haml'

  gem.authors       = ["shooma", "waxerdima"]
  gem.email         = ["neshooma@mail.ru", "shooma@mishkov@gmail.com"]
  gem.description   = %q{Штука, позволяющая искать записи по ассоциированным моделям прямо в форме}
  gem.summary       = %q{Штука, позволяющая искать записи по ассоциированным моделям прямо в форме}

  gem.files         = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.test_files    = Dir["spec/**/*"]
  gem.require_paths = ["lib", "app"]
end
