module ActiveTranslation
  module Translatable
    extend ActiveSupport::Concern

    class_methods do
      def translates(*attributes, manual: [], into:, unless: nil, only: nil)
        @translation_config ||= {}
        @translation_config[:attributes] = attributes
        @translation_config[:manual_attributes] = Array(manual)
        @translation_config[:locales] = into
        @translation_config[:unless] = binding.local_variable_get(:unless)
        @translation_config[:only] = binding.local_variable_get(:only)

        has_many :translations, class_name: "ActiveTranslation::Translation", as: :translatable, dependent: :destroy

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

        Array(manual).each do |attr|
          define_method("#{attr}") do |locale: nil|
            if locale && translation = translations.find_by(locale: locale.to_s)
              JSON.parse(translation.translated_attributes)[attr.to_s].presence || read_attribute(attr)
            else
              read_attribute(attr)
            end
          end

          into.each do |locale|
            define_method("#{attr}_#{locale}=") do |value|
              translation = translations.find_or_initialize_by(translatable_type: self.class.name, translatable_id: self.id, locale: locale.to_s)
              attrs = translation.translated_attributes ? JSON.parse(translation.translated_attributes) : {}
              attrs[attr.to_s] = value
              translation.translated_attributes = attrs.to_json
              translation.source_checksum ||= calculate_checksum(attributes)
              translation.save!
            end

            define_method("#{attr}_#{locale}") do
              translation = translations.find_by(locale: locale.to_s)
              return read_attribute(attr) unless translation

              JSON.parse(translation.translated_attributes)[attr.to_s].presence || read_attribute(attr)
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

      if config[:unless] && evaluate_condition(config[:unless])
        self.translations.destroy_all
        return
      end

      if config[:only] && !evaluate_condition(config[:only])
        self.translations.destroy_all
        return
      end

      # if just the only/unless constraint has changed
      if !saved_changes.keys.intersect?(config[:attributes].map(&:to_s))
        return unless (config[:unless] && !evaluate_condition(config[:unless])) || (config[:only] && evaluate_condition(config[:only]))
      end

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

    private

    def evaluate_condition(condition)
      case condition
      when Symbol
        send(condition)
      when Proc
        instance_exec(&condition)
      else
        false
      end
    end
  end
end
