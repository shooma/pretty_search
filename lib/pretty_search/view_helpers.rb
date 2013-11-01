# encoding: utf-8
module PrettySearch
  module ViewHelpers
    # Public: Хелпер для вывода инпутов и кнопки.
    #
    # Returns hidden input, input и button
    def input_with_search(*args)
      opts = args.extract_options!
      approved_options = [:model_name, :search_type, :field_name, :field_list, :order, :limit]
      render :partial => 'pretty_search/buttons', :locals => { :options => opts.slice(*approved_options) }
    end

    # Public: Прверяет, нужно ли обрезать показываемую пользователю информацию.
    # Выясняет это по типу поля в модели. Если это :text - возвращает true, надо укорачивать.
    #
    # Returns bool.
    def need_cut?(record, attr)
      record.column_for_attribute(attr).type == :text
    end
  end
end