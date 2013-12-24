# encoding: utf-8
# Public: Реализует метод поиска, также хранит в себе знание о поле,
# списке возвращаемых полей и классе поиска.
#
# Examples
#
#   searcher.handle(query) => ActiveRecord::Relation
module PrettySearch
  class Searcher
    # Public: Задает/считывает класс, по которому будем искать записи.
    attr_accessor :model_class

    # Public: Задает/считывает поле, по которому будем искать записи.
    # Инстанс класса "PrettySearch::Field"
    attr_accessor :field

    # Public: Задает/считывает список возвращаемых БД полей.
    attr_accessor :field_list

    # Public: Инициализирует поисковик.
    #
    # args - хэш опций, необходимых для инициализации:
    #        :model_name - Строка с именем модели (обяз.).
    #        :field_name - Строка с именем поля, по которому
    #                      будет осуществлятсья поиск (необяз.).
    #        :field_list - Массив строк - имен возвращаемых полей (необяз.).
    def initialize(*args)
      opts = args.extract_options!

      set_model_for opts[:model_name]
      set_field_for opts[:field_name]
      set_field_list_for(opts[:model_name], opts[:field_list])

      validate_availability
    end

    # Public: Формирует и выполняет запрос к БД, если:
    # 1. Будет пройдена валидация поля поиска и возвращаемых полей.
    # 2. Метод поиска ('query.search_type') включен в список
    # разрешенных к использованию методов ('PrettySearch.accessible_search_methods').
    #
    # query - Инстанс класса 'PrettySearch::Query' (обяз.).
    #
    # Returns объект 'ActiveRecord::Relation', либо рейзит одно из следующих исключений:
    # 1. 'PrettySearch::WrongSearchTypeError'
    # 2. 'PrettySearch::UnavailableFieldError'
    def handle(query)
      condition = model_class.arel_table[field.name].send(query.search_type, query.value)

      default_scopes = model_class.
        select(field_list).
        where(condition).
        order(query.order).
        page(query.page).
        per(query.limit)

      add_extra_scopes_for(default_scopes, query)
    end

    protected

    # Internal: Вычленяет класс из переданной строки - имени класса,
    # и записывает его в переменную @model_class.
    #
    # model_name - Строка, имя класса (обяз.).
    #
    # Returns class.
    def set_model_for(model_name)
      self.model_class = model_name.classify.constantize
    end

    # Internal: Создает объект поля (по которому будет осуществляться поиск),
    # и записывает его в переменную @field.
    #
    # field_name - Строка, имя поля.
    #
    # Returns инстанс класса 'PrettySearch::Field'.
    def set_field_for(field_name = nil)
      self.field = PrettySearch::Field.new(model_class, field_name)
    end

    # Internal: Формирует список возвращаемых селектом полей, и складывает его в переменную @field_list.
    # Если список передан аргументов, то просто складывает его в переменную.
    # Если не передан, то смотрит список для конкретной модели в переменной 'PrettySearch.fields'.
    # Если не находит списка полей и там, то берет дефолтные из 'PrettySearch.default_selected_fields'.
    #
    # model_name - Строка, имя класса (обяз.).
    # list       - Массив строк - имен возвращаемых полей (необяз.).
    #
    # Returns массив символов - имен возвращаемых полей.
    def set_field_list_for(model_name, list = nil)
      self.field_list = list ||
                        PrettySearch.fields.stringify_keys[model_name] ||
                        PrettySearch.default_selected_fields
    end

    # Internal: Проверяет, можно ли искать по переданному полю, и можно ли возвращать переданный список полей
    #
    # Returns error, if field or field_list is unavailable.
    def validate_availability
      unless PrettySearch.available_for_use?(model_class.name.underscore, [field.name]) &&
          PrettySearch.available_for_use?(model_class.name.underscore, field_list)
        raise PrettySearch::UnavailableFieldError
      end
    end

    # Internal: Добавляет к пользовательскому условию выборки стандартные задаываемые условия
    #
    # results - Экземпляр класса 'ActiveRecord::Relation' (обяз.).
    # query   - Экземпляр класса 'PrettySearch::Query' (обяз.).
    def add_extra_scopes_for(results, query)
      return results if query.extra_scopes.blank?
      query.extra_scopes.each do |scope|
        results = results.send(scope)
      end
      results
    end
  end
end
