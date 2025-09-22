module ActiveTranslations
  class TranslationJob < ActiveJob::Base
    queue_as :default

    def perform(model_class, record_id, locale, checksum)
      model = model_class.safe_constantize.find(record_id)
      config = model.class.translation_config

      translated_data = {}
      config[:attributes].each do |attr|
        source_text = model.read_attribute(attr)
        translated_data[attr.to_s] = translate_text(source_text, locale)
      end

      model.translations
        .find_or_initialize_by(
          translatable_type: model_class,
          translatable_id: model.id,
          locale: locale,
        )
        .update!(
          translated_attributes: translated_data.to_json,
          source_checksum: checksum
        )
    end

    private

    def translate_text(text, target_locale)
      return "[#{target_locale}] #{text}" if Rails.env.test?

      GoogleTranslate.translate(target_language_code: target_locale, text: text)
    end
  end
end
