# encoding: utf-8
module PrettySearch
  class PrettySearchController < ActionController::Base

    SEARCH_PARAMS = %w(field_name field_list model_name)
    QUERY_PARAMS  = %w(limit offset order page q search_type)

    def search
      if PrettySearch.authorised
        search_params = params.slice(*SEARCH_PARAMS).symbolize_keys
        query_params = params.slice(*QUERY_PARAMS).symbolize_keys

        searcher = PrettySearch::Searcher.new(search_params)
        query = PrettySearch::Query.new(query_params)

        @options = {
            model_name: search_params[:model_name],
            field_name: searcher.field.name,
            field_list: searcher.field_list
        }

        @results = searcher.handle(query)
      else
        redirect_to PrettySearch.auth_url if PrettySearch.auth_url.present?
        raise PrettySearch::NotSpecifiedUrlError
      end
    end

  end
end
