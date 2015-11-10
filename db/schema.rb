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

ActiveRecord::Schema.define(version: 20151108171957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "callers", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "song_id"
    t.integer  "caller_id"
    t.integer  "singing_id"
  end

  add_index "calls", ["caller_id"], name: "index_calls_on_caller_id", using: :btree
  add_index "calls", ["singing_id"], name: "index_calls_on_singing_id", using: :btree
  add_index "calls", ["song_id"], name: "index_calls_on_song_id", using: :btree

  create_table "singings", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "location",   null: false
    t.string   "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "singings", ["name", "date"], name: "index_singings_on_name_and_date", unique: true, using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "number",              null: false
    t.string   "name",                null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "book_id"
    t.string   "title_ordinal"
    t.string   "meter_name"
    t.string   "meter_count"
    t.text     "song_text"
    t.string   "composer_first_name"
    t.string   "composer_last_name"
    t.string   "composition_date"
    t.string   "poet_first_name"
    t.string   "post_last_name"
  end

  add_index "songs", ["book_id"], name: "index_songs_on_book_id", using: :btree
  add_index "songs", ["name", "title_ordinal", "book_id"], name: "index_songs_on_name_and_title_ordinal_and_book_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "token",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

  add_foreign_key "calls", "callers"
  add_foreign_key "calls", "singings"
  add_foreign_key "calls", "songs"
  add_foreign_key "songs", "books"
end
