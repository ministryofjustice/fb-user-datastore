# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_16_194026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "service_slug"
    t.string "encrypted_payload"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validity"
    t.text "encrypted_email", null: false
    t.text "validation_url", null: false
    t.json "template_context"
    t.index ["service_slug", "encrypted_email"], name: "index_emails_on_service_slug_and_encrypted_email"
  end

  create_table "magic_links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "service_slug", null: false
    t.text "email", null: false
    t.text "encrypted_email", null: false
    t.text "validity", default: "valid", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "validation_url", null: false
    t.json "template_context"
    t.index ["service_slug", "encrypted_email"], name: "index_magic_links_on_service_slug_and_encrypted_email"
  end

  create_table "mobiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "service_slug"
    t.string "mobile"
    t.text "encrypted_email"
    t.text "encrypted_payload"
    t.datetime "expires_at"
    t.string "validity", default: "valid", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "save_returns", force: :cascade do |t|
    t.text "encrypted_email", null: false
    t.text "encrypted_payload", null: false
    t.text "service_slug", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_slug", "encrypted_email"], name: "index_save_returns_on_service_slug_and_encrypted_email", unique: true
  end

  create_table "user_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_identifier"
    t.string "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service_slug"
    t.index ["service_slug", "user_identifier"], name: "index_user_data_on_service_slug_and_user_identifier", unique: true
  end

end
