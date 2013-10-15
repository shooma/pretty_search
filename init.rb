Dir[File.dirname(__FILE__) + "/lib/*.rb"].each { |filename| require filename }
Dir[File.dirname(__FILE__) + "/app/*.rb"].each { |filename| require filename }
