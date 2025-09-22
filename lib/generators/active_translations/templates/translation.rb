class Translation < ApplicationRecord
  belongs_to :translatable, polymorphic: true

  validates :locale, presence: true, uniqueness: { scope: [ :translatable_type, :translatable_id ] }
  validates :source_checksum, presence: true
end
