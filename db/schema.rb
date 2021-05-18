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

ActiveRecord::Schema.define(version: 2021_05_12_215512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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

  create_table "feedback_dates", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "list_module_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "feedback_status", default: "not_approved"
    t.boolean "reminder_sent", default: false
    t.boolean "period_open_sent", default: false
    t.index ["list_module_id"], name: "index_feedback_dates_on_list_module_id"
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
    t.integer "level"
    t.string "team_type", default: "random"
    t.string "mailmerge_message", default: ""
  end

  create_table "peer_feedbacks", force: :cascade do |t|
    t.string "created_by"
    t.string "created_for"
    t.string "status", default: "in_progress"
    t.integer "attendance"
    t.integer "attitude"
    t.integer "qac"
    t.integer "communication"
    t.integer "collaboration"
    t.integer "leadership"
    t.integer "ethics"
    t.string "appreciate", default: ""
    t.string "request", default: ""
    t.string "appreciate_edited", default: ""
    t.string "request_edited", default: ""
    t.bigint "feedback_date_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feedback_date_id"], name: "index_peer_feedbacks_on_feedback_date_id"
  end

  create_table "problem_notes", force: :cascade do |t|
    t.string "created_by"
    t.string "note"
    t.bigint "problem_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_id"], name: "index_problem_notes_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "created_by"
    t.string "status", default: "unsolved"
    t.string "assigned_to"
    t.string "note"
    t.string "solved_by"
    t.datetime "solved_on"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_problems_on_team_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "team_feedback_dates", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "feedback_date_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feedback_date_id"], name: "index_team_feedback_dates_on_feedback_date_id"
    t.index ["team_id"], name: "index_team_feedback_dates_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "topic", default: "none"
    t.integer "size"
    t.bigint "list_module_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "toa_status", default: "in_progress"
    t.string "status", default: "waiting_for_approval"
    t.index ["list_module_id"], name: "index_teams_on_list_module_id"
  end

  create_table "tmr_signatures", force: :cascade do |t|
    t.string "signed_by"
    t.datetime "signed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tmr_id", null: false
    t.index ["tmr_id"], name: "index_tmr_signatures_on_tmr_id"
  end

  create_table "tmrs", force: :cascade do |t|
    t.string "status", default: "in_progress"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_tmrs_on_team_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "feedback_dates", "list_modules"
  add_foreign_key "peer_feedbacks", "feedback_dates"
  add_foreign_key "problem_notes", "problems"
  add_foreign_key "problems", "teams"
  add_foreign_key "team_feedback_dates", "feedback_dates"
  add_foreign_key "team_feedback_dates", "teams"
  add_foreign_key "teams", "list_modules"
  add_foreign_key "tmr_signatures", "tmrs"
  add_foreign_key "tmrs", "teams"
  add_foreign_key "user_list_modules", "list_modules"
  add_foreign_key "user_list_modules", "users"
  add_foreign_key "user_teams", "teams"
  add_foreign_key "user_teams", "users"
end
