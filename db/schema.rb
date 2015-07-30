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

ActiveRecord::Schema.define(version: 20150702054219) do

  create_table "breeders", force: :cascade do |t|
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "reference"
    t.datetime "last_seen_at"
    t.string   "phone_number"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "breeders", ["latitude", "longitude"], name: "index_breeders_on_latitude_and_longitude"
  add_index "breeders", ["reference"], name: "index_breeders_on_reference", unique: true

  create_table "breeders_breeds", id: false, force: :cascade do |t|
    t.integer "breeder_id"
    t.integer "breed_id"
  end

  add_index "breeders_breeds", ["breed_id"], name: "index_breeders_breeds_on_breed_id"
  add_index "breeders_breeds", ["breeder_id"], name: "index_breeders_breeds_on_breeder_id"

  create_table "breeds", force: :cascade do |t|
    t.integer  "family_id"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "url"
  end

  add_index "breeds", ["family_id"], name: "index_breeds_on_family_id"
  add_index "breeds", ["name"], name: "index_breeds_on_name"

  create_table "families", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "families", ["name"], name: "index_families_on_name", unique: true

  create_table "litters", force: :cascade do |t|
    t.integer  "breeder_id"
    t.integer  "breed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "litters", ["breed_id"], name: "index_litters_on_breed_id"
  add_index "litters", ["breeder_id"], name: "index_litters_on_breeder_id"

end
