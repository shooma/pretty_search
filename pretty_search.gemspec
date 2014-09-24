# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'pretty_search'
  gem.version       = '0.2.1'

  gem.add_runtime_dependency 'rails', '~> 3'
  gem.add_runtime_dependency 'haml', '>= 0'
  gem.add_runtime_dependency 'kaminari', '>= 0.14'

  gem.add_development_dependency 'haml'
  gem.add_development_dependency 'kaminari', '>= 0.14'
  gem.add_development_dependency 'rspec-rails', '~> 2.13'
  gem.add_development_dependency 'activerecord-postgresql-adapter'
  gem.add_development_dependency 'shoulda-matchers', '~> 1.5.2'
  gem.add_development_dependency 'factory_girl_rails'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'database_cleaner'

  gem.authors       = %w(shooma waxerdima)
  gem.email         = %w(shooma.mishkov@gmail.com)
  gem.description   = %q{Form searcher, simplifying select associated models}
  gem.summary       = %q{Form searcher}

  gem.files         = Dir['{app,config,db,lib}/**/*'] + %w(LICENSE.txt Rakefile README.rdoc)
  gem.test_files    = Dir['spec/**/*']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = %w(lib app)
end
