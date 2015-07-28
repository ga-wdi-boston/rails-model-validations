# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150728200308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer "person_id"
    t.integer "place_id"
    t.date    "from"
    t.date    "to"
  end

  add_index "addresses", ["person_id"], name: "index_addresses_on_person_id", using: :btree
  add_index "addresses", ["place_id"], name: "index_addresses_on_place_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "developers", force: :cascade do |t|
    t.string   "given_name"
    t.string   "surname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "company_id"
    t.integer "developer_id"
    t.integer "salary"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree
  add_index "jobs", ["developer_id"], name: "index_jobs_on_developer_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "surname"
    t.string   "given_name"
    t.string   "gender"
    t.string   "dob"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "middle_name"
    t.integer  "place_id"
  end

  add_index "people", ["place_id"], name: "index_people_on_place_id", using: :btree

  create_table "pets", force: :cascade do |t|
    t.string   "name"
    t.string   "species"
    t.string   "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id"
  end

  add_index "pets", ["person_id"], name: "index_pets_on_person_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "city"
    t.string   "state"
    t.integer  "population"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "country"
  end

  add_foreign_key "addresses", "people"
  add_foreign_key "addresses", "places"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "developers"
  add_foreign_key "people", "places"
  add_foreign_key "pets", "people"
end
