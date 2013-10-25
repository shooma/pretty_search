module PrettySearch
  class PrettyError < StandardError
    def initialize(msg = I18n.t("pretty_search.errors.#{self.class.name.demodulize.underscore}"))
      super(msg)
    end
  end

  class NotSpecifiedUrlError < PrettyError; end
  class WrongSearchTypeError < PrettyError; end
  class UnavailableFieldError < PrettyError; end
end