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

ActiveRecord::Schema[7.2].define(version: 2026_11_17_000200) do
  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_gems", force: :cascade do |t|
    t.string "title", null: false
    t.string "short_desc", null: false
    t.text "long_desc"
    t.text "image"
    t.string "location", null: false
    t.integer "tag_id", null: false
    t.integer "category_id", null: false
    t.integer "neighbourhood_id", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_city_gems_on_category_id"
    t.index ["neighbourhood_id"], name: "index_city_gems_on_neighbourhood_id"
    t.index ["tag_id"], name: "index_city_gems_on_tag_id"
  end

  create_table "neighbourhoods", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "tag_id", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pin"
    t.index ["tag_id"], name: "index_neighbourhoods_on_tag_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
  end

  create_table "property_neighbourhoods", force: :cascade do |t|
    t.integer "property_id", null: false
    t.integer "neighbourhood_id", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neighbourhood_id"], name: "index_property_neighbourhoods_on_neighbourhood_id"
    t.index ["property_id", "neighbourhood_id"], name: "idx_on_property_id_neighbourhood_id_4d2c9f3800", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "title", null: false
    t.string "hashtag", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashtag"], name: "index_tags_on_hashtag", unique: true
  end

  add_foreign_key "city_gems", "categories"
  add_foreign_key "city_gems", "neighbourhoods"
  add_foreign_key "city_gems", "tags"
  add_foreign_key "neighbourhoods", "tags"
  add_foreign_key "property_neighbourhoods", "neighbourhoods"
  add_foreign_key "property_neighbourhoods", "properties"
end
