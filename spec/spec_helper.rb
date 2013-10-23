# encoding: utf-8
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require 'fixtures/application'
require 'fixtures/controllers'

require 'pretty_search'

RSpec.configure do |config|
  config.order = "random"
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation
end
