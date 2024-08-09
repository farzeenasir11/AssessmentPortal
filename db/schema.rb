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

ActiveRecord::Schema[7.1].define(version: 2024_08_05_095020) do
  create_table "assessments", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_assessments_on_project_id"
  end

  create_table "options", force: :cascade do |t|
    t.text "content", null: false
    t.boolean "is_right", default: false, null: false
    t.integer "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "content", null: false
    t.integer "assessment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_questions_on_assessment_id"
  end

  create_table "user_assessments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "assessment_id", null: false
    t.integer "score"
    t.datetime "attempted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_user_assessments_on_assessment_id"
    t.index ["user_id"], name: "index_user_assessments_on_user_id"
  end

  create_table "user_projects", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "assigned_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "user_results", force: :cascade do |t|
    t.integer "user_assessment_id", null: false
    t.integer "question_id", null: false
    t.integer "option_id", null: false
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_user_results_on_option_id"
    t.index ["question_id"], name: "index_user_results_on_question_id"
    t.index ["user_assessment_id"], name: "index_user_results_on_user_assessment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "assessments", "projects"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "assessments"
  add_foreign_key "user_assessments", "assessments"
  add_foreign_key "user_assessments", "users"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
  add_foreign_key "user_results", "options"
  add_foreign_key "user_results", "questions"
  add_foreign_key "user_results", "user_assessments"
end
