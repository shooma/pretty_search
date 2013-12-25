# encoding: utf-8
# Public: Реализует объект, хранит в себе знания о запросе,
# списке возвращаемых полей и классе поиска.
#
# Examples
#
#   query.limit => 5
#   query.search_type => 'matches'
module PrettySearch
  class Query
    # Public: Задает/считывает основные опции запроса:
    #
    # value        - Поисковый запрос.
    # limit        - Число результатов на странице
    # page         - Номер возвращаемой страницы.
    # order        - Сортировка результатов по полю. Символ (имя поля).
    # search_type  - Тип поиска. По дефолту один из методов-предикатов Arel'a:
    # http://rubydoc.info/github/rails/arel/master/Arel/Predications
    # extra_scopes - Дополнительные условия поиска (а-ля скоупов 'active', или [:where, "state = 'active'"])
    attr_accessor :value, :limit, :page, :order, :search_type, :extra_scopes

    DEFAULT_LIMIT = 10
    DEFAULT_LIMIT_MAX = 100
    DEFAULT_PAGE = 1
    DEFAULT_ORDER = 'id'
    DEFAULT_SEARCH_TYPE = 'eq'
    DEFAULT_EXTRA_SCOPES = []

    # Public: Инициализирует запрос.
    #
    # args - Хеш опций. Обязателен только запрос ({:q => ...}),
    # остальные опции имеют дефолтные значения.
    def initialize(*args)
      opts = args.extract_options!

      limit = opts.fetch(:limit, DEFAULT_LIMIT)

      self.limit = [limit, DEFAULT_LIMIT_MAX].min
      self.page = opts.fetch(:page, DEFAULT_PAGE)
      self.order = opts.fetch(:order, DEFAULT_ORDER)
      self.search_type = opts.fetch(:search_type, DEFAULT_SEARCH_TYPE)
      self.extra_scopes = opts.fetch(:extra_scopes, DEFAULT_EXTRA_SCOPES)

      validate_search_type

      self.value = grind_value(opts[:q])
      # для обработки диапазонов нужно писать логику
    end

    protected

    # Internal: Для запросов с типом поиска 'matches', 'matches_any' etc
    # стрипит, заменяет множественные пробелы одиночными,
    # и оборачивает запрос в '%%'
    #
    # Returns String.
    def grind_value(value)
      /match/.match(search_type) ? "%#{value.strip.gsub(/\s+/, ' ')}%" : value
    end

    # Internal: Проверяет, указан ли выбранный пользователем тип поиска
    # в списке разрешенных к использованию методов
    #
    # Returns error, if search_type unavailable. Else returns nothing.
    def validate_search_type
      unless PrettySearch.accessible_search_methods.include? search_type
        raise PrettySearch::WrongSearchTypeError
      end
    end
  end
end