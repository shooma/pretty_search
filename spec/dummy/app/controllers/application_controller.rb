class ApplicationController < ActionController::Base
  protect_from_forgery
  helper PrettySearch::Engine.helpers
end
