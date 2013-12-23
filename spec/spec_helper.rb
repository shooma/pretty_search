# encoding: utf-8
require 'rubygems'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require "factory_girl_rails"

require 'pretty_search'
#require 'factories'
Dir[Rails.root.join('spec/factories/*.rb')].each { |f| require f }


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.order = :random
  config.formatter = :documentation
  config.color_enabled = true
  config.tty = true
end

#class Field
#  attr_accessor :name, :type
#  def initialize(attributes = {})
#    @name = attributes[:name]
#    @type = attributes[:type]
#  end
#end
