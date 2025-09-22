module ActiveTranslations
  class Engine < ::Rails::Engine
    isolate_namespace ActiveTranslations

    initializer "active_translations.model" do
      ActiveSupport.on_load(:active_record) do
        include ActiveTranslations::Translatable
      end
    end
  end
end
