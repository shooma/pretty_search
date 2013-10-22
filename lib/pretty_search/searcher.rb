# encoding: utf-8
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
      validate_fields_availability

      if PrettySearch.accessible_search_methods.include?(query.search_type.to_sym)
        condition = model_class.arel_table[field.name].send(query.search_type, query.value)

        model_class.
          select(field_list).
          where(condition).
          order(query.order).
          page(query.page).
          per(query.limit)
      else
        raise PrettySearch::WrongSearchTypeError
      end
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
      list ||= PrettySearch.fields[model_name.to_sym] || PrettySearch.default_selected_fields
      self.field_list = list.map(&:to_sym) if list
    end

    # Internal: Проверяет @field и @field_list на возможность быть использованными и выбранными.
    # Если все в порядке, то не вернет ничего.
    # Если не все - срейзит ошибку 'PrettySearch::UnavailableFieldError'
    #
    #
    #
    def validate_fields_availability
      # some fuzzy logic with enabled and disabled fields
      model_name = model_class.to_s.downcase.to_sym
      used_fields = field_list | [field.name.to_sym]

      if PrettySearch.disabled_fields.any?
        if PrettySearch.disabled_fields.keys.include? model_name
          if (used_fields & PrettySearch.disabled_fields[model_name]).any?
            raise PrettySearch::UnavailableFieldError
          end
        end
      elsif PrettySearch.enabled_fields.any?
        if PrettySearch.enabled_fields.keys.include? model_name
          if (used_fields - PrettySearch.enabled_fields[model_name]).any?
            raise PrettySearch::UnavailableFieldError
          end
        else
          raise PrettySearch::UnavailableFieldError
        end
      end
    end
  end
end
