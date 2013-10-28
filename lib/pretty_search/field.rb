# encoding: utf-8
# Public: Реализует методы атрибутов и параметров поля,
# по которому осуществляется поиск.
#
# Examples
#
#   field.name => 'title'
#   field.type => :string
module PrettySearch
  class Field
    # Public: Задает/считывает имя и тип поля, к которому поле относится.
    attr_accessor :name, :type

    # Public: Инициализирует поле.
    #
    # model_class - Класс, по которому будет осуществляться поиск (обяз.).
    # field_name  - Строка с именем поля, по которому
    #               будет осуществлятсья поиск (необяз.).
    def initialize(model_class, field_name = nil)
      # Если поле не передано, пробуем стандартные, указанные в конфиге поля
      field_name ||= PrettySearch.default_search_fields.detect{ |meth| model_class.attribute_method? meth }

      unless field_name.nil?
        self.name = field_name
        self.type = model_class.columns_hash[name].type
      end
    end
  end
end
