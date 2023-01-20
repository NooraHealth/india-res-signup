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

ActiveRecord::Schema.define(version: 2022_12_16_130926) do

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
    t.bigint "state_id"
    t.index ["condition_area_id"], name: "index_exophones_on_condition_area_id"
    t.index ["language_id"], name: "index_exophones_on_language_id"
    t.index ["program_id"], name: "index_exophones_on_program_id"
    t.index ["state_id"], name: "index_exophones_on_state_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_hospitals_on_state_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "iso_code"
  end

  create_table "noora_programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
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
    t.bigint "state_id"
    t.index ["condition_area_id"], name: "index_textit_groups_on_condition_area_id"
    t.index ["program_id"], name: "index_textit_groups_on_program_id"
    t.index ["state_id"], name: "index_textit_groups_on_state_id"
  end

  create_table "user_condition_area_mappings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "condition_area_id"
    t.bigint "noora_program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_area_id"], name: "index_user_condition_area_mappings_on_condition_area_id"
    t.index ["noora_program_id"], name: "index_user_condition_area_mappings_on_noora_program_id"
    t.index ["user_id"], name: "index_user_condition_area_mappings_on_user_id"
  end

  create_table "user_signup_trackers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "condition_area_id"
    t.bigint "noora_program_id"
    t.bigint "language_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_area_id"], name: "index_user_signup_trackers_on_condition_area_id"
    t.index ["language_id"], name: "index_user_signup_trackers_on_language_id"
    t.index ["noora_program_id"], name: "index_user_signup_trackers_on_noora_program_id"
    t.index ["user_id"], name: "index_user_signup_trackers_on_user_id"
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
    t.integer "hospital_id"
    t.string "whatsapp_mobile_number"
    t.integer "state_id"
    t.bigint "states_id"
    t.boolean "whatsapp_number_confirmed", default: false
    t.datetime "ivr_unsubscribe_date"
    t.datetime "whatsapp_unsubscribe_date"
    t.index ["condition_area_id"], name: "index_users_on_condition_area_id"
    t.index ["language_preference_id"], name: "index_users_on_language_preference_id"
    t.index ["program_id"], name: "index_users_on_program_id"
    t.index ["states_id"], name: "index_users_on_states_id"
  end

  add_foreign_key "exophones", "condition_areas"
  add_foreign_key "exophones", "languages"
  add_foreign_key "exophones", "noora_programs", column: "program_id"
  add_foreign_key "hospitals", "states"
  add_foreign_key "textit_group_user_mappings", "textit_groups"
  add_foreign_key "textit_group_user_mappings", "users"
  add_foreign_key "textit_groups", "condition_areas"
  add_foreign_key "textit_groups", "languages"
  add_foreign_key "textit_groups", "noora_programs", column: "program_id"
  add_foreign_key "user_condition_area_mappings", "condition_areas"
  add_foreign_key "user_condition_area_mappings", "noora_programs"
  add_foreign_key "user_condition_area_mappings", "users"
  add_foreign_key "user_signup_trackers", "condition_areas"
  add_foreign_key "user_signup_trackers", "languages"
  add_foreign_key "user_signup_trackers", "noora_programs"
  add_foreign_key "user_signup_trackers", "users"
  add_foreign_key "users", "condition_areas"
  add_foreign_key "users", "hospitals"
  add_foreign_key "users", "languages", column: "language_preference_id"
  add_foreign_key "users", "noora_programs", column: "program_id"
  add_foreign_key "users", "states"
end
