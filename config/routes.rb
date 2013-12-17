# encoding: utf-8
PrettySearch::Engine.routes.draw do
  match 'query/:model_name' => 'pretty_search#search', :as => :query, :via => :get
end