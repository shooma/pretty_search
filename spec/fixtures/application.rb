require 'active_support/all'
require 'action_controller'
require 'action_dispatch'

module Rails
  class App
    def env_config; {} end
    def routes
      return @routes if defined?(@routes)
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        #resources :posts # Replace with your own needs
        match 'query/:model_name' => 'pretty_search#search', :as => :query, :via => :get
      end
      @routes
    end
  end

  def self.application
    @app ||= App.new
  end
end