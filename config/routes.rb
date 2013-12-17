# encoding: utf-8
Rails.application.routes.draw do
  get 'query/:model_name' => 'pretty_search/pretty_search#search', :as => :query
end