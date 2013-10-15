# encoding: utf-8
module PrettySearch
  class Query
    attr_accessor :value, :limit, :page, :order, :search_type

    DEFAULT_LIMIT = 10
    DEFAULT_PAGE = 1
    DEFAULT_ORDER = :id
    DEFAULT_SEARCH_TYPE = 'eq'

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

    # Для запросов с типом поиска 'matches', 'matches_any' etc
    # оборачиваем запрос в '%%'
    def grind_value(value)
      /\Amatches/.match(search_type) ? "%#{value.strip.gsub(/\s+/, ' ')}%" : value
    end
  end
end