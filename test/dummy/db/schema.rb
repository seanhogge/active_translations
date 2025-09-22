# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_22_161056) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "translations", force: :cascade do |t|
    t.string "translatable_type", null: false
    t.integer "translatable_id", null: false
    t.string "locale", null: false
    t.text "translated_attributes"
    t.string "source_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_type", "translatable_id", "locale"], name: "index_translations_on_translatable_and_locale", unique: true
    t.index ["translatable_type", "translatable_id"], name: "index_translations_on_translatable"
  end
end
