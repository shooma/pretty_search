#require 'active_support/core_ext/string' #used for '.blank?' method
#
class Field
  attr_accessor :name, :type
  def initialize(attributes = {})
    @name = attributes[:name]
    @type = attributes[:type]
  end
end

class Company
  attr_accessor :title
  def initialize(attributes = {})
    @title  = attributes[:title]
  end

  def self.columns_hash
    @@columns_hash
  end

  def self.set_columns_hash
    @@columns_hash = { 'title' => Field.new({ :name => :title, :type => :string }) }
  end

  def self.attribute_method?(meth)
    meth == 'title'
  end
end

class Mug
  attr_accessor :volume
  def initialize(attributes = {})
    @volume = attributes[:volume]
  end

  def self.columns_hash
    @@columns_hash
  end

  def self.set_columns_hash
    @@columns_hash = { 'volume' => Field.new({ :name => :volume, :type => :fixnum }) }
  end

  def self.attribute_method?(meth)
    meth == 'volume'
  end
end

Company.set_columns_hash
Mug.set_columns_hash

