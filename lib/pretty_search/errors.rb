module PrettySearch
  class PrettyError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  class NotSpecifiedUrlError < PrettyError
    def initialize(msg = I18n.t('pretty_search.errors.not_specified_url'))
      super(msg)
    end
  end

  class WrongSearchTypeError < PrettyError
    def initialize(msg = I18n.t('pretty_search.errors.wrong_search_type'))
      super(msg)
    end
  end

  class UnavailableFieldError < PrettyError
    def initialize(msg = I18n.t('pretty_search.errors.unavailable_field'))
      super(msg)
    end
  end
end