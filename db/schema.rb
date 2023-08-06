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

ActiveRecord::Schema[7.0].define(version: 2023_08_06_083550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "condition_areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["state_id"], name: "index_districts_on_state_id"
  end

  create_table "exophones", force: :cascade do |t|
    t.string "virtual_number"
    t.integer "language_id"
    t.integer "condition_area_id"
    t.integer "program_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "state_id"
    t.index ["condition_area_id"], name: "index_exophones_on_condition_area_id"
    t.index ["language_id"], name: "index_exophones_on_language_id"
    t.index ["program_id"], name: "index_exophones_on_program_id"
    t.index ["state_id"], name: "index_exophones_on_state_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["state_id"], name: "index_hospitals_on_state_id"
  end

  create_table "import_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "iso_code"
  end

  create_table "noora_programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "onboarding_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "qr_codes", force: :cascade do |t|
    t.string "name"
    t.string "link_encoded"
    t.bigint "state_id"
    t.bigint "noora_program_id"
    t.string "text_identifier"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "condition_area_id"
    t.string "text_encoded"
    t.index ["condition_area_id"], name: "index_qr_codes_on_condition_area_id"
    t.index ["noora_program_id"], name: "index_qr_codes_on_noora_program_id"
    t.index ["state_id"], name: "index_qr_codes_on_state_id"
  end

  create_table "rch_profiles", force: :cascade do |t|
    t.string "name"
    t.text "health_facility"
    t.text "health_block"
    t.text "health_sub_facility"
    t.text "village"
    t.string "rch_id"
    t.string "husband_name"
    t.integer "mother_age"
    t.text "anm_name"
    t.string "anm_contact"
    t.string "asha_contact"
    t.datetime "registration_date", precision: nil
    t.text "high_risk_details"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "asha_name"
    t.integer "case_no"
    t.boolean "high_risk_pregnancy", default: false
    t.string "mobile_of"
    t.string "address"
    t.string "med_past_illness"
    t.datetime "rch_visit_1_date", precision: nil
    t.datetime "rch_visit_2_date", precision: nil
    t.datetime "rch_visit_3_date", precision: nil
    t.datetime "rch_visit_4_date", precision: nil
    t.datetime "rch_visit_5_date", precision: nil
    t.datetime "rch_visit_6_date", precision: nil
    t.datetime "rch_visit_7_date", precision: nil
    t.datetime "rch_visit_8_date", precision: nil
    t.string "district"
    t.index ["user_id"], name: "index_rch_profiles_on_user_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "textit_group_user_mappings", force: :cascade do |t|
    t.integer "textit_group_id"
    t.integer "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["textit_group_id"], name: "index_textit_group_user_mappings_on_textit_group_id"
    t.index ["user_id"], name: "index_textit_group_user_mappings_on_user_id"
  end

  create_table "textit_groups", force: :cascade do |t|
    t.string "name"
    t.integer "program_id"
    t.string "textit_id"
    t.integer "condition_area_id"
    t.string "exotel_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "language_id"
    t.bigint "state_id"
    t.bigint "onboarding_method_id"
    t.bigint "qr_code_id"
    t.index ["condition_area_id"], name: "index_textit_groups_on_condition_area_id"
    t.index ["onboarding_method_id"], name: "index_textit_groups_on_onboarding_method_id"
    t.index ["program_id"], name: "index_textit_groups_on_program_id"
    t.index ["qr_code_id"], name: "index_textit_groups_on_qr_code_id"
    t.index ["state_id"], name: "index_textit_groups_on_state_id"
  end

  create_table "user_condition_area_mappings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "condition_area_id"
    t.bigint "noora_program_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "active", default: true
    t.index ["condition_area_id"], name: "index_user_condition_area_mappings_on_condition_area_id"
    t.index ["noora_program_id"], name: "index_user_condition_area_mappings_on_noora_program_id"
    t.index ["user_id"], name: "index_user_condition_area_mappings_on_user_id"
  end

  create_table "user_import_job_items", force: :cascade do |t|
    t.bigint "user_import_job_id", null: false
    t.bigint "user_id", null: false
    t.bigint "import_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_message"
    t.index ["import_status_id"], name: "index_user_import_job_items_on_import_status_id"
    t.index ["user_id"], name: "index_user_import_job_items_on_user_id"
    t.index ["user_import_job_id"], name: "index_user_import_job_items_on_user_import_job_id"
  end

  create_table "user_import_jobs", force: :cascade do |t|
    t.datetime "import_date"
    t.integer "number_of_users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_program_trackers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "noora_program_id"
    t.boolean "active", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["noora_program_id"], name: "index_user_program_trackers_on_noora_program_id"
    t.index ["user_id"], name: "index_user_program_trackers_on_user_id"
  end

  create_table "user_signup_trackers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "condition_area_id"
    t.bigint "noora_program_id"
    t.bigint "language_id"
    t.boolean "active", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "state_id"
    t.string "call_sid"
    t.bigint "onboarding_method_id"
    t.boolean "completed"
    t.string "sms_id"
    t.bigint "qr_code_id"
    t.bigint "exophone_id"
    t.datetime "completed_at", precision: nil
    t.string "call_status"
    t.string "campaign_sid"
    t.string "call_direction"
    t.datetime "event_timestamp", precision: nil
    t.string "platform"
    t.index ["call_sid"], name: "index_user_signup_trackers_on_call_sid"
    t.index ["condition_area_id"], name: "index_user_signup_trackers_on_condition_area_id"
    t.index ["exophone_id"], name: "index_user_signup_trackers_on_exophone_id"
    t.index ["language_id"], name: "index_user_signup_trackers_on_language_id"
    t.index ["noora_program_id"], name: "index_user_signup_trackers_on_noora_program_id"
    t.index ["onboarding_method_id"], name: "index_user_signup_trackers_on_onboarding_method_id"
    t.index ["qr_code_id"], name: "index_user_signup_trackers_on_qr_code_id"
    t.index ["state_id"], name: "index_user_signup_trackers_on_state_id"
    t.index ["user_id"], name: "index_user_signup_trackers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mobile_number"
    t.datetime "baby_date_of_birth", precision: nil
    t.datetime "date_of_discharge", precision: nil
    t.datetime "incoming_call_date", precision: nil
    t.integer "program_id"
    t.integer "condition_area_id"
    t.integer "language_preference_id"
    t.boolean "language_selected", default: false
    t.boolean "signed_up_to_whatsapp", default: false
    t.boolean "signed_up_to_ivr", default: false
    t.string "textit_uuid"
    t.string "whatsapp_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "hospital_id"
    t.string "whatsapp_mobile_number"
    t.integer "state_id"
    t.bigint "states_id"
    t.boolean "whatsapp_number_confirmed", default: false
    t.datetime "ivr_unsubscribe_date", precision: nil
    t.datetime "whatsapp_unsubscribe_date", precision: nil
    t.datetime "last_menstrual_period", precision: nil
    t.datetime "expected_date_of_delivery", precision: nil
    t.bigint "onboarding_method_id"
    t.datetime "whatsapp_onboarding_date", precision: nil
    t.integer "onboarding_attempts", default: 0
    t.datetime "qr_scan_date", precision: nil
    t.boolean "registered_on_whatsapp", default: true
    t.integer "reference_user_id"
    t.index ["condition_area_id"], name: "index_users_on_condition_area_id"
    t.index ["language_preference_id"], name: "index_users_on_language_preference_id"
    t.index ["mobile_number"], name: "index_users_on_mobile_number"
    t.index ["onboarding_method_id"], name: "index_users_on_onboarding_method_id"
    t.index ["program_id"], name: "index_users_on_program_id"
    t.index ["states_id"], name: "index_users_on_states_id"
  end

  add_foreign_key "districts", "states"
  add_foreign_key "exophones", "condition_areas"
  add_foreign_key "exophones", "languages"
  add_foreign_key "exophones", "noora_programs", column: "program_id"
  add_foreign_key "hospitals", "states"
  add_foreign_key "qr_codes", "noora_programs"
  add_foreign_key "qr_codes", "states"
  add_foreign_key "rch_profiles", "users"
  add_foreign_key "textit_group_user_mappings", "textit_groups"
  add_foreign_key "textit_group_user_mappings", "users"
  add_foreign_key "textit_groups", "condition_areas"
  add_foreign_key "textit_groups", "languages"
  add_foreign_key "textit_groups", "noora_programs", column: "program_id"
  add_foreign_key "user_condition_area_mappings", "condition_areas"
  add_foreign_key "user_condition_area_mappings", "noora_programs"
  add_foreign_key "user_condition_area_mappings", "users"
  add_foreign_key "user_import_job_items", "import_statuses"
  add_foreign_key "user_import_job_items", "user_import_jobs"
  add_foreign_key "user_import_job_items", "users"
  add_foreign_key "user_program_trackers", "noora_programs"
  add_foreign_key "user_program_trackers", "users"
  add_foreign_key "user_signup_trackers", "condition_areas"
  add_foreign_key "user_signup_trackers", "languages"
  add_foreign_key "user_signup_trackers", "noora_programs"
  add_foreign_key "user_signup_trackers", "users"
  add_foreign_key "users", "condition_areas"
  add_foreign_key "users", "hospitals"
  add_foreign_key "users", "languages", column: "language_preference_id"
  add_foreign_key "users", "noora_programs", column: "program_id"
  add_foreign_key "users", "onboarding_methods"
  add_foreign_key "users", "states"
end
