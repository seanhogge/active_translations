module ActiveTranslation
  class Engine < ::Rails::Engine
    isolate_namespace ActiveTranslation

    initializer "active_translation.model" do
      ActiveSupport.on_load(:active_record) do
        include ActiveTranslation::Translatable
      end
    end
  end
end
