require 'pretty_search/view_helpers'

module PrettySearch
  class Railtie < Rails::Railtie
    initializer "pretty_search.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end