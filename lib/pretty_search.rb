# encoding: utf-8
require "pretty_search/engine"

module PrettySearch

  autoload :Field,                  'pretty_search/field'
  autoload :Searcher,               'pretty_search/searcher'
  autoload :Query,                  'pretty_search/query'

  require_relative 'pretty_search/errors.rb'

  # Public: Поля, по которым будет осуществляться поиск,
  # в случае, если :field_name не указан явно при вызове хелпера
  mattr_accessor :default_search_fields
  self.default_search_fields = %w(title name)

  # Public: Хэш, где ключом является символьное имя класса, по которому будет осуществляться поиск,
  # а значение - массив символов - имен возвращаемых колонок в БД.
  #
  # Examples
  #
  #   PrettySearch.fields => { :company => %w(id title updated_at) }
  mattr_accessor :fields
  self.fields = {}

  # Public: Массив возвращаемых селектом полей, если список полей
  # (1) не передан из view,
  # (2) не найден в полях для конкретного класса 'PrettySearch.fields[<model_name>]'
  mattr_accessor :default_selected_fields
  self.default_selected_fields = %w(:id)

  # Public: Переменная-флаг, сообщающая контроллеру права пользователя на доступ к БД.
  # Если не менять эту переменную, то любой пользователь, обладающий правильной ссылкой получит искомые данные
  #
  # Examples
  #
  #   PrettySearch.authorised = -> { PrettySearch::PrettySearchController.user_signed_in? }
  mattr_accessor :authorised
  self.authorised = true

  # Public: URL, на который будем отправлять пользователя, для которого
  # PrettySearch.authorised разрешается в false
  mattr_accessor :auth_url

  # Список разрешенных к использованию для поиска методов,
  # по дефолту - список поисковых методов-предикатов, расчитаных на один аргумент:
  # Arel::Predications.public_instance_methods(false).reject{ |meth| meth.match(/(_all\z)|(_any\z)/) }
  mattr_accessor :accessible_search_methods
  self.accessible_search_methods = %w(not_eq eq matches does_not_match gteq gt lt lteq)

  # Public: Задает/считывает список разрешенных к поиску и селекту полей таблиц.
  # Ниже по приоритету чем 'disabled_fields', т.е. если в 'disabled_fields' для модели указаны какие-то поля,
  # то эта переменная использоваться не будет.
  #
  # Examples
  #
  #  self.enabled_fields = {:company => %w(title main_region)}
  #
  #  Также вместо массива имен полей можно передать символ :all:
  #  self.enabled_fields = {:company => :all}
  mattr_accessor :enabled_fields
  self.enabled_fields = {}

  # Public: Задает/считывает список запрещенных к поиску и селекту полей таблиц.
  # Приоритетнее чем 'enabled_fields'.
  #
  # Examples
  #
  #  self.disabled_fields = {:user => %w(auth_token reg_token)}
  #
  #  Также вместо массива имен полей можно передать символ :all:
  #  self.enabled_fields = {:company => :all}
  mattr_accessor :disabled_fields
  self.disabled_fields = {}

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
  #  # В pretty_search.rb
  #  mattr_accessor :foo
  #
  #  # В приложении
  #  PrettySearch.setup do |config|
  #    config.foo = 'bar'
  #  end
  #
  #  # Или
  #  PrettySearch.setup(foo: 'bar')
  #
  #  PrettySearch.foo # => 'bar'
  #
  # Returns nothing
  def self.setup(options = nil)
    if options.is_a? Hash
      options.each { |option, value| self.send("#{option}=", value) }
    elsif block_given?
      yield self
    end
  end

  # Public: Проверяет, разрешено ли искать записи по переданным полям,
  # т.е. проверяет переменные @enabled_fields и @disabled_fields на присутствие
  # в них указанных полей, и на этом основании делает вывод, можно ли использовать
  # этот набор полей.
  #
  # Если поле не указано в запрещенном списке, проверяем, есль ли записи в разрешенном.
  # Если список разрешенных полей пуст, делаем вывод, что поле доступно пользователю.
  # Если же в переменной @enabled_fields есть хотя бы одна запись, и наше поле
  # не прописано в разрешенных, то считаем искомое поле недоступным.
  #
  # Т.е. если разрешенный список пуст, то не отдаем запрещенные поля ('disabled_fields').
  # Если же разрешенные поля есть, то сначала отбрасываем запрещенные, а потом все, кроме разрешенных.
  #
  # Examples
  #
  #   # in initializer:
  #   config.disabled_fields = {:company => %w(token)}
  #
  #   # in controller:
  #   PrettySearch.available_for_use?('company', ['token']) => false
  #   PrettySearch.available_for_use?('company', ['title']) => true
  #   PrettySearch.available_for_use?('user', ['name'])     => true
  #
  #
  #   добавив разрешенные поля, получим:
  #
  #   # in initializer:
  #   config.disabled_fields = {:user => %w(token)}
  #   config.enabled_fields = {:company => %w(title)}
  #
  #   # in controller:
  #   PrettySearch.available_for_use?('user', ['token'])     => false
  #   PrettySearch.available_for_use?('user', ['name'])      => true
  #   PrettySearch.available_for_use?('company', ['title'])  => true
  #   PrettySearch.available_for_use?('company', ['region']) => false
  #
  # model_name - Строка, имя модели.
  # fields - Массив полей указанной выше модели.
  #
  # Returns bool.
  def self.available_for_use?(model_name, fields)
    disabled = disabled_fields.stringify_keys
    enabled  = enabled_fields.stringify_keys

    if disabled.has_key? model_name
      disabled[model_name].equal?(:all) ? false : (fields & disabled[model_name]).none?
    elsif enabled.any?
      if enabled.has_key? model_name
        enabled[model_name].equal?(:all) ? true : (fields - enabled[model_name]).none?
      else
        false
      end
    else
      true
    end
  end
end