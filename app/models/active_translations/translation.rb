module ActiveTranslations
  class Translation < ApplicationRecord
    self.table_name = :translations

    belongs_to :translatable, polymorphic: true

    validates :locale, presence: true, uniqueness: { scope: [ :translatable_type, :translatable_id ] }
    validates :source_checksum, presence: true
  end
end
