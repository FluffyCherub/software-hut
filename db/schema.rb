# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_04_200921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "list_modules", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.string "created_by"
    t.string "semester"
    t.string "years"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "team_operating_agreements", force: :cascade do |t|
    t.string "project_name", default: ""
    t.string "module_name", default: ""
    t.string "module_leader", default: ""
    t.string "team_name", default: ""
    t.string "start_date", default: ""
    t.string "end_date", default: ""
    t.string "team_mission", default: ""
    t.string "team_communications", default: ""
    t.string "decision_making", default: ""
    t.string "meetings", default: ""
    t.string "personal_courtesies", default: ""
    t.string "status", default: "in_progress"
    t.datetime "last_opened"
    t.datetime "last_edited"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_team_operating_agreements_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "topic"
    t.integer "size"
    t.bigint "list_module_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_module_id"], name: "index_teams_on_list_module_id"
  end

  create_table "toa_signatures", force: :cascade do |t|
    t.string "name", default: ""
    t.string "signature", default: ""
    t.string "date", default: ""
    t.bigint "team_operating_agreement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_operating_agreement_id"], name: "index_toa_signatures_on_team_operating_agreement_id"
  end

  create_table "user_list_modules", force: :cascade do |t|
    t.bigint "list_module_id", null: false
    t.bigint "user_id", null: false
    t.string "privilege"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_module_id"], name: "index_user_list_modules_on_list_module_id"
    t.index ["user_id"], name: "index_user_list_modules_on_user_id"
  end

  create_table "user_teams", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.boolean "signed_agreement", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_user_teams_on_team_id"
    t.index ["user_id"], name: "index_user_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "uid"
    t.string "mail"
    t.string "ou"
    t.string "dn"
    t.string "sn"
    t.string "givenname"
    t.boolean "admin", default: false
    t.boolean "suspended", default: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "team_operating_agreements", "teams"
  add_foreign_key "teams", "list_modules"
  add_foreign_key "toa_signatures", "team_operating_agreements"
  add_foreign_key "user_list_modules", "list_modules"
  add_foreign_key "user_list_modules", "users"
  add_foreign_key "user_teams", "teams"
  add_foreign_key "user_teams", "users"
end
