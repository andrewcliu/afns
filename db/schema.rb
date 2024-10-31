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

ActiveRecord::Schema.define(version: 2024_10_31_020557) do

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

  create_table "afns_class_attendances", force: :cascade do |t|
    t.bigint "afns_class_schedule_id"
    t.date "attendance_date"
    t.integer "attendance_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["afns_class_schedule_id"], name: "index_afns_class_attendances_on_afns_class_schedule_id"
  end

  create_table "afns_class_schedules", force: :cascade do |t|
    t.bigint "afns_class_id"
    t.string "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["afns_class_id"], name: "index_afns_class_schedules_on_afns_class_id"
  end

  create_table "afns_classes", force: :cascade do |t|
    t.string "name"
    t.string "instructor"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room"
  end

  create_table "guest_agreements", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "staff"
    t.boolean "is_guest_pass"
    t.boolean "has_paid"
    t.boolean "has_toured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zip_code"
    t.string "signature"
  end

  create_table "lockers", force: :cascade do |t|
    t.string "locker_number"
    t.string "first_name"
    t.string "key_tag_number"
    t.string "receipt_number"
    t.date "expiration_date"
    t.string "staff_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.index ["locker_number", "gender"], name: "index_lockers_on_locker_number_and_gender", unique: true
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "membership_number"
    t.date "date_join"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_number"], name: "index_members_on_membership_number", unique: true
  end

  create_table "trainer_forms", force: :cascade do |t|
    t.string "name"
    t.string "membership_number"
    t.date "date_of_birth"
    t.string "reasons"
    t.string "phone"
    t.text "medical_conditions"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waivers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.bigint "afns_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "signature"
    t.index ["afns_class_id"], name: "index_waivers_on_afns_class_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "afns_class_attendances", "afns_class_schedules"
  add_foreign_key "afns_class_schedules", "afns_classes"
end
