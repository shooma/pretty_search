# encoding: utf-8
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require 'fixtures/application'
#require 'fixtures/controllers'

require 'pretty_search'
require_relative '../app/controllers/pretty_search/pretty_search_controller.rb'

RSpec.configure do |config|
  config.order = :random
  config.formatter = :documentation
  config.color_enabled = true
  config.tty = true
end
