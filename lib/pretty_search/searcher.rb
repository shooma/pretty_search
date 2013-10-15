# encoding: utf-8
module PrettySearch
  class Searcher
    attr_accessor :model_class, :field, :field_list

    # При инициализации инстанса поисковика,
    # в качестве аргумента обрабатывается хеш
    # (только ключи :model_name - обяз., :field_name - необяз., :field_list - необяз.)
    # на основании переданного хеша билдятся:
    # (1) "self.model_class", как класс, по которому будет осуществляться поиск
    # (2) "self.field", как инстанс класса "PrettySearch::Field"
    # (3) "self.field_list", как массив символов - имен колонок в БД
    def initialize(*args)
      opts = args.extract_options!

      set_model_for opts[:model_name]
      set_field_for opts[:field_name]
      set_field_list_for(opts[:model_name], opts[:field_list])
    end

    # Метод, осуществляющий поиск
    # Обязательный аргумент - инстанс класса 'PrettySearch::Query'
    # Возвращает 'Relation'
    def handle(query)
      condition = model_class.arel_table[field.name].send(query.search_type, query.value)

      model_class.
        select(field_list).
        where(condition).
        order(query.order).
        page(query.page).
        per(query.limit)
    end

    protected

    # Получаем класс из переданной строки - имени класса
    def set_model_for(model_name)
      self.model_class = model_name.classify.constantize
    end

    # Создаем объект поля (по которому будет осуществляться поиск)
    def set_field_for(field_name = nil)
      self.field = PrettySearch::Field.new(model_class, field_name)
    end

    # Получаем список атрибутов, которые будем выбирать из базы,
    # и в конечном счете строить по ним таблицу для отображения в шаблоне.
    # Если не передан список выбираемых полей, будут взяты поля,
    # описанные в 'pretty_config.yml'
    def set_field_list_for(model_name, list = nil)
      list ||= PrettySearch.fields[model_name.to_sym] || PrettySearch.default_selected_fields
      self.field_list = list.map(&:to_sym) if list
    end
  end
end
