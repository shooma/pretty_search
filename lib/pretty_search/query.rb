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

      self.limit = opts.fetch(:limit, DEFAULT_LIMIT)
      self.page = opts.fetch(:page, DEFAULT_PAGE)
      self.order = opts.fetch(:order, DEFAULT_ORDER)
      self.search_type = opts.fetch(:search_type, DEFAULT_SEARCH_TYPE)
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
      /\Amatch/.match(search_type) ? "%#{value.strip.gsub(/\s+/, ' ')}%" : value
    end
  end
end