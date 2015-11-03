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

ActiveRecord::Schema.define(version: 20151103212113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "callers", force: :cascade do |t|
    t.string   "name"
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
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "book_id"
  end

  add_index "songs", ["book_id"], name: "index_songs_on_book_id", using: :btree

  add_foreign_key "calls", "callers"
  add_foreign_key "calls", "singings"
  add_foreign_key "calls", "songs"
  add_foreign_key "songs", "books"
end
