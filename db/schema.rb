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

ActiveRecord::Schema[7.0].define(version: 2023_05_25_152104) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "codes", force: :cascade do |t|
    t.text "service_slug", null: false
    t.text "encrypted_email", null: false
    t.text "code", null: false
    t.text "validity", default: "valid", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["service_slug", "encrypted_email"], name: "index_codes_on_service_slug_and_encrypted_email"
  end

  create_table "emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "service_slug"
    t.string "encrypted_payload"
    t.datetime "expires_at", precision: nil
    t.string "validity"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "encrypted_email", null: false
    t.index ["service_slug", "encrypted_email"], name: "index_emails_on_service_slug_and_encrypted_email"
  end

  create_table "magic_links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "service_slug", null: false
    t.text "encrypted_email", null: false
    t.text "validity", default: "valid", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["service_slug", "encrypted_email"], name: "index_magic_links_on_service_slug_and_encrypted_email"
  end

  create_table "mobiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "service_slug", null: false
    t.text "encrypted_email", null: false
    t.text "encrypted_payload", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.text "validity", default: "valid", null: false
    t.text "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["service_slug", "encrypted_email"], name: "index_mobiles_on_service_slug_and_encrypted_email"
  end

  create_table "save_returns", force: :cascade do |t|
    t.text "encrypted_email", null: false
    t.text "encrypted_payload", null: false
    t.text "service_slug", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["service_slug", "encrypted_email"], name: "index_save_returns_on_service_slug_and_encrypted_email", unique: true
  end

  create_table "saved_forms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "secret_question"
    t.string "secret_answer"
    t.string "page_slug"
    t.string "service_slug"
    t.string "service_version"
    t.string "user_id"
    t.string "user_token"
    t.text "user_data_payload"
    t.integer "attempts", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret_question_text"
  end

  create_table "user_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_identifier"
    t.string "payload"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "service_slug"
    t.index ["service_slug", "user_identifier"], name: "index_user_data_on_service_slug_and_user_identifier", unique: true
  end

end
