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

ActiveRecord::Schema.define(version: 2022_08_24_203509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "condition_areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exophones", force: :cascade do |t|
    t.string "virtual_number"
    t.integer "language_id"
    t.integer "condition_area_id"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_area_id"], name: "index_exophones_on_condition_area_id"
    t.index ["language_id"], name: "index_exophones_on_language_id"
    t.index ["program_id"], name: "index_exophones_on_program_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "noora_programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "textit_group_user_mappings", force: :cascade do |t|
    t.integer "textit_group_id"
    t.integer "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["textit_group_id"], name: "index_textit_group_user_mappings_on_textit_group_id"
    t.index ["user_id"], name: "index_textit_group_user_mappings_on_user_id"
  end

  create_table "textit_groups", force: :cascade do |t|
    t.string "name"
    t.integer "program_id"
    t.string "textit_id"
    t.integer "condition_area_id"
    t.string "exotel_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["condition_area_id"], name: "index_textit_groups_on_condition_area_id"
    t.index ["program_id"], name: "index_textit_groups_on_program_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mobile_number"
    t.datetime "baby_date_of_birth"
    t.datetime "date_of_discharge"
    t.datetime "incoming_call_date"
    t.integer "program_id"
    t.integer "condition_area_id"
    t.integer "language_preference_id"
    t.boolean "language_selected", default: false
    t.boolean "signed_up_to_whatsapp", default: false
    t.boolean "signed_up_to_ivr", default: false
    t.string "textit_uuid"
    t.string "whatsapp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_area_id"], name: "index_users_on_condition_area_id"
    t.index ["language_preference_id"], name: "index_users_on_language_preference_id"
    t.index ["program_id"], name: "index_users_on_program_id"
  end

end
