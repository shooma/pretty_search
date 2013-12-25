# PrettySearch :rocket:

Штука, реализующая поиск по произвольному атрибуту произвольной модели.
Предназначена для использования в формах.

Поиск осуществляется через arel. Доступны все типы поиска, им реализованные.
Возвращаемые результаты пагинируются kaminari.

## Installation

Добавь в Gemfile:
```
gem 'pretty_search', :git => 'git@github.com:shooma/pretty_search.git'
```

В application.js (или в сборку, в которой собираетесь использовать) добавляем
```
//= require reference
```
куда-нибудь после jQuery.

Прописать стили в файле сборки (например у нас это `active_admin.scss.erb`):
```
@import "pretty_search";
```

Чтобы запросы начали ходить, то в том же инишиалайзере нужно добавить условие,
по которму будет проверяться (в простейшем случае) авторизован ли пользователь,
и (необязатнльно) URL, на который будет перенаправлен пользователь, если `authorised` разрешается в false:
```
#less config/initializers/pretty_search.rb
PrettySearch::PrettySearchController.send(:before_filter, :authenticate_user!)
PrettySearch::PrettySearchController.send(:extend, Devise::Controllers::Helpers)

PrettySearch.setup do |config|
  # Лямбда-флаг, возвращающий true если пользователь имеет право на доступ к ресурсам проекта
  config.authorised = -> { return PrettySearch::PrettySearchController.user_signed_in? }

  config.auth_url = '/'
end
```
Дефолтно
```
authorised = false
auth_url = nil
```

## Usage

Например в форме реактирования пользователя нам нужно
выбрать компанию для привязки, но в селектбокс компании не засунешь, потому что их over 100500:

```
= form_for user do |f|
  = f.input :name
  -# ...
  = input_with_search(:model_name => 'company', :field_name => 'title', :field_list => [:id, :title], :search_type => 'matches')
  -# ...
```

Результатом рендера хелпера `input_with_search` станут input, hidden input и кнопка, разворачивающая попап c поиском.

Для тех, кто использует active_admin или formtastic есть написанный инпут для *.arb файлов:

```
div do
  active_admin_form_for [:admin, bill] do |f|
    f.inputs do
      ...
      f.input :company, :as => :string_with_search, :search => { :search_type => 'matches' }, :input_html => { :class => 'short-string' }
      ...
    end
  end
end
```

Основные настройки (поле, по которому осуществлять поиск у конкретной модели; набор возвращаемых в попап по дефолту полей итп) можно задать так:

```
#less config/initializers/pretty_search.rb
PrettySearch.setup do |config|
  # Дефолтные поля, по которым будем пытаться искать, если конкретных значений не передано
  config.default_search_fields = [:title, :name]

  # Задаем возвращаемые поля для конкретных классов
  config.fields = {
    :company => [:id, :title, :source_id],
    :payer => [:id, :title, :inn, :kpp]
  }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
