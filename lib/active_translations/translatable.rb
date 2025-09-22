module ActiveTranslations
  module Translatable
    extend ActiveSupport::Concern

    class_methods do
      def translates(*attributes, into:, unless: nil, only: nil)
        @translation_config ||= {}
        @translation_config[:attributes] = attributes
        @translation_config[:locales] = into
        @translation_config[:unless] = binding.local_variable_get(:unless)
        @translation_config[:only] = binding.local_variable_get(:only)

        has_many :translations, as: :translatable, dependent: :destroy

        # Generate locale-specific methods
        into.each do |locale|
          define_method("#{locale}_translation") do
            translations.find_by(locale: locale.to_s)
          end
        end

        # Override attribute methods
        attributes.each do |attr|
          define_method(attr) do |locale: nil|
            if locale && translation = translations.find_by(locale: locale.to_s)
              JSON.parse(translation.translated_attributes)[attr.to_s]
            else
              super()
            end
          end
        end

        after_commit :queue_translations, on: [ :create, :update ]
      end

      def translation_config
        @translation_config
      end
    end

    def queue_translations
      config = self.class.translation_config
      return if config[:unless] && send(config[:unless])
      return if config[:only] && !send(config[:only])
      return unless saved_changes.keys.intersect? config[:attributes].map(&:to_s)

      current_checksum = calculate_checksum(config[:attributes])

      config[:locales].each do |locale|
        translation = translations.find_or_initialize_by(locale: locale.to_s)

        if translation.new_record? || translation.source_checksum != current_checksum
          TranslationJob.perform_later(self.class.name, id, locale.to_s, current_checksum)
        end
      end
    end

    def calculate_checksum(attributes)
      values = attributes.map { |attr| read_attribute(attr).to_s }
      Digest::MD5.hexdigest(values.join)
    end
  end
end
