module ActiveTranslation
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

      translation = model.translations
        .find_or_initialize_by(
          translatable_type: model_class,
          translatable_id: model.id,
          locale: locale,
        )

      existing_data =
        begin
          translation.translated_attributes.present? ? JSON.parse(translation.translated_attributes) : {}
        rescue JSON::ParserError
          {}
        end

      merged_attributes = existing_data.merge(translated_data)

      translation.update!(
        translated_attributes: merged_attributes.to_json,
        source_checksum: checksum
      )
    end

    private

    def translate_text(text, target_locale)
      return "[#{target_locale}] #{text}" if Rails.env.test?

      ActiveTranslation::GoogleTranslate.translate(target_language_code: target_locale, text: text)
    end
  end
end
