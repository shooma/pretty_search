# encoding: utf-8
module PrettySearch
  class PrettySearchController < ActionController::Base

    SEARCH_PARAMS = %w(field_name field_list model_name)
    QUERY_PARAMS  = %w(limit offset order page q search_type)

    # Public: Задает/считывает две переменные, далее используемые во вью
    # В @options хранятся данные, необходимые для построения таблицы,
    # а в @results - результат выполнения запроса, данные. заполняющие таблицу.
    attr_accessor :options, :results

    # Public: Метод, который обрабатывает пользовательские запросы-выборки.
    #
    # Returns две переменные инстанса (в нормальном режиме):
    # @options - имена модели и полей.
    # @results - 'ActiveRecord::Relation' с выбранными результатами.
    # Либо же редиректит на указанный в переменной 'PrettySearch.auth_url',
    # если у пользователя нет прав на просмотр данной страницы, 'auth_url' присутствует.
    #
    # Если поле, по которому нужно осуществить поиск, либо какое-то из возвращаемых полей
    # не доступно к использованию гемом, вернется 500 'PrettySearch::UnavailableFieldError'.
    def search
      if PrettySearch.authorised
        search_params = params.slice(*SEARCH_PARAMS).symbolize_keys
        query_params = params.slice(*QUERY_PARAMS).symbolize_keys

        searcher = PrettySearch::Searcher.new(search_params)
        query = PrettySearch::Query.new(query_params)

        self.options = {
          model_name: search_params[:model_name],
          field_name: searcher.field.name,
          field_list: searcher.field_list
        }

        self.results = searcher.handle(query)
      else
        return redirect_to PrettySearch.auth_url if PrettySearch.auth_url.present?
        raise PrettySearch::NotSpecifiedUrlError
      end
    end

  end
end
