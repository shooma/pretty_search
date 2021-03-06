# encoding: utf-8
require 'rubygems'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

require 'pretty_search'

Dir[Rails.root.join('spec/factories/*.rb')].each { |f| require f }


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.order = :random
  config.formatter = :documentation
  config.color_enabled = true
  config.tty = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end