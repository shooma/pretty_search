# encoding: utf-8
Rails.application.routes.draw do
  match 'pretty_search/query/:model_name' => 'pretty_search#search', :as => :query, :via => :get
end