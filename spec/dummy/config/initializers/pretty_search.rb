# encoding: utf-8
PrettySearch::PrettySearchController.send(:include, Rails.application.routes.url_helpers)
#PrettySearch::PrettySearchController.send(:before_filter, :authenticate_user!)
#PrettySearch::PrettySearchController.send(:extend, Devise::Controllers::Helpers)

PrettySearch.setup do |config|
  # Лямбда-флаг, возвращающий true если пользователь имеет право на доступ к ресурсам проекта
  config.authorised = true

  # Дефолтные поля, по которым будем пытаться искать, если конкретных значений не передано
  config.default_search_fields = %w(title name)

  # Задаем возвращаемые поля для конкретных классов
  #config.fields = {
  #  :company => %w(id source_id title),
  #  :payer => %w(id title self_payer)
  #}
  #
  #config.disabled_fields = {
  #  :company => %w(gg muahaha)
  #}
  #
  #config.enabled_fields = {
  #  :payer => %w(id title self_payer)
  #}
end