require "active_translations/version"
require "active_translations/engine"
require "active_translations/configuration"
require "active_translations/translatable"
require "active_translations/translation_job"

module ActiveTranslations
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
