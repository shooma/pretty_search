module PrettySearch
  class Field
    attr_accessor :name, :type

    def initialize(model_class, field_name = nil)
      # Если поле не передано, пробуем стандартные, указанные в конфиге поля
      if field_name.nil?
        field_name = model_class.attribute_names.detect{ |v| PrettySearch.default_search_fields.include? v.to_sym }
      end

      unless field_name.nil?
        self.name = field_name
        self.type = model_class.columns_hash[name].type
      end
    end
  end
end
