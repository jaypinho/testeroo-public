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

ActiveRecord::Schema.define(version: 20170228033931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "metric_id"
    t.integer  "test_id"
    t.integer  "test_slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id"], name: "index_assignments_on_metric_id", using: :btree
    t.index ["test_id"], name: "index_assignments_on_test_id", using: :btree
  end

  create_table "metrics", force: :cascade do |t|
    t.string   "name"
    t.text     "definition"
    t.string   "ad_format"
    t.string   "environment"
    t.integer  "test_slots_count"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "suite_id"
    t.string   "metric_type"
    t.integer  "max_days_since_last_passed_test"
    t.index ["suite_id"], name: "index_metrics_on_suite_id", using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.integer  "test_id"
    t.boolean  "passed"
    t.text     "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.string   "jira"
    t.index ["test_id"], name: "index_results_on_test_id", using: :btree
    t.index ["user_id"], name: "index_results_on_user_id", using: :btree
  end

  create_table "suites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "max_days_since_last_passed_test"
  end

  create_table "tests", force: :cascade do |t|
    t.text     "description"
    t.text     "expected_result"
    t.string   "test_link"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "role",       default: "normal"
  end

  add_foreign_key "assignments", "metrics"
  add_foreign_key "assignments", "tests"
  add_foreign_key "metrics", "suites"
  add_foreign_key "results", "tests"
  add_foreign_key "results", "users"
end
