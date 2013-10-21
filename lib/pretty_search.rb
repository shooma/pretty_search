# encoding: utf-8
require "pretty_search/engine"

module PrettySearch

  require 'pretty_search/railtie' if defined?(Rails)

  autoload :Field,                  'pretty_search/field'
  autoload :Searcher,               'pretty_search/searcher'
  autoload :Query,                  'pretty_search/query'

  require_relative '../app/controllers/pretty_search/pretty_search_controller.rb'
  require_relative '../app/controllers/pretty_search_controller.rb'
  require_relative 'pretty_search/errors.rb'

  # Поля, по которым будет осуществляться поиск,
  # в случае, если :field_name не указан явно при вызове хелпера
  mattr_accessor :default_search_fields
  self.default_search_fields = [:title, :name]

  # Хэш, где ключом является символьное имя класса, по которому будет осуществляться поиск,
  # а значение - массив символов - имен возвращаемых колонок в БД, а-ля:
  # { :company => [:id, :title, :updated_at] }
  mattr_accessor :fields
  self.fields = {}

  # Массив возвращаемых селектом полей, если список полей
  # (1) ни передан из view,
  # (2) ни найден в полях для конкретного класса 'PrettySearch.fields[<model_name>]'
  mattr_accessor :default_selected_fields
  self.default_selected_fields = [:id]

  # Переменная-флаг, сообщающая контроллеру права пользователя на доступ к БД.
  # Если не менять эту переменную, то любой пользователь, обладающий правильной ссылкой получит искомые данные
  mattr_accessor :authorised
  self.authorised = true

  # URL, на который будем отправлять пользователя, для которого
  # PrettySearch.authorised разрешается в false
  mattr_accessor :auth_url

  # Список разрешенных к использованию для поиска методов,
  # по дефолту - список поисковых методов-предикатов
  mattr_accessor :accessible_search_methods
  self.authorised = Arel::Predications.public_instance_methods(false)

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