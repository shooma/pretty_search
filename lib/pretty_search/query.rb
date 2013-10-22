# encoding: utf-8
module PrettySearch
  class Query
    # Public: Задает/считывает основные опции запроса:
    #
    # value       - Поисковый запрос.
    # limit       - Число результатов на странице
    # page        - Номер возвращаемой страницы.
    # order       - Сортировка результатов по полю. Символ (имя поля).
    # search_type - Тип поиска. По дефолту один из методов-предикатов Arel'a:
    # http://rubydoc.info/github/rails/arel/master/Arel/Predications
    attr_accessor :value, :limit, :page, :order, :search_type

    DEFAULT_LIMIT = 10
    DEFAULT_PAGE = 1
    DEFAULT_ORDER = :id
    DEFAULT_SEARCH_TYPE = 'eq'

    # Public: Инициализирует запрос.
    #
    # args - Хеш опций. Обязателен только запрос ({:q => ...}),
    # остальные опции имеют дефолтные значения.
    def initialize(*args)
      opts = args.extract_options!

      self.limit = opts[:limit] || DEFAULT_LIMIT
      self.page = opts[:page] || DEFAULT_PAGE
      self.order = opts[:order] || DEFAULT_ORDER
      self.search_type = opts[:search_type] || DEFAULT_SEARCH_TYPE
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
      /\Amatches/.match(search_type) ? "%#{value.strip.gsub(/\s+/, ' ')}%" : value
    end
  end
end