# encoding: utf-8
require 'rubygems'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require 'fixtures/application'

require 'pretty_search'

RSpec.configure do |config|
  config.order = :random
  config.formatter = :documentation
  config.color_enabled = true
  config.tty = true
end
