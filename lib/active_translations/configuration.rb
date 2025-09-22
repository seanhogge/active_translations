module ActiveTranslations
  class Configuration
    attr_accessor :google_api_key

    def initialize
      @google_api_key = nil
    end
  end
end
