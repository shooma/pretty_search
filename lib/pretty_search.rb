# encoding: utf-8
module PrettySearch

  autoload :Field,                  'pretty_search/field'
  autoload :Searcher,               'pretty_search/searcher'
  autoload :Query,                  'pretty_search/query'

  autoload :PrettySearchController, 'pretty_search/app/controllers/pretty_search/pretty_search_controller'
  autoload :PrettySearchHelper,     'pretty_search/app/helpers/pretty_search_helper'

  # Поля, по которым будет осуществляться поиск,
  # в случае, если :field_name не указан явно при вызове хелпера
  mattr_accessor :default_search_fields
  self.default_search_fields ||= [:title, :name]

  # Хэш, где ключом является символьное имя класса, по которому будет осуществляться поиск,
  # а значение - массив символов - имен возвращаемых колонок в БД, а-ля:
  # { :company => [:id, :title, :updated_at] }
  mattr_accessor :fields
  self.fields ||= {}

  # Массив возвращаемых селектом полей, если список полей
  # (1) ни передан из view,
  # (2) ни найден в полях для конкретного класса 'PrettySearch.fields[<model_name>]'
  mattr_accessor :default_selected_fields
  self.default_selected_fields ||= [:id]

  # Public: Метод для настройки PrettySearch
  # Параметры в PrettySearch могут быть определены через mattr_accessor
  # NOTE: В случае если опции не хэш, то они просто игнорируются
  #
  # options - Hash с опциями, которые необходимо установить (default: nil)
  # См. все атрибуты модуля
  #
  # Yields self
  #
  # Examples
  #
  # # В pretty_search.rb
  # mattr_accessor :foo
  #
  # # В приложении
  # PrettySearch.setup do |config|
  #   config.foo = 'bar'
  # end
  #
  # # Или
  # PrettySearch.setup(foo: 'bar')
  #
  # PrettySearch.foo # => 'bar'
  #
  # Returns nothing
  def self.setup(options = nil)
    if options.is_a? Hash
      options.each { |option, value| self.send("#{option}=", value) }
    elsif block_given?
      yield self
    end
  end
end