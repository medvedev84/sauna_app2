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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111119193412) do

  create_table "addresses", :force => true do |t|
    t.integer   "sauna_id"
    t.integer   "city_id"
    t.integer   "district_id"
    t.string    "street"
    t.string    "building"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "sauna_id"
    t.string   "email"
    t.string   "phone_number"
    t.string   "fio"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.boolean   "is_all"
    t.string    "name"
    t.integer   "city_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "price"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sauna_comments", :force => true do |t|
    t.string    "user_name"
    t.string    "description"
    t.integer   "sauna_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sauna_items", :force => true do |t|
    t.boolean   "has_veniki"
    t.boolean   "has_mangal"
    t.boolean   "has_pool"
    t.string    "name"
    t.integer   "sauna_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "description"
    t.integer   "sauna_type_id"
    t.boolean   "has_kitchen"
    t.boolean   "has_restroom"
    t.boolean   "has_billiards"
    t.boolean   "has_audio"
    t.boolean   "has_video"
    t.boolean   "has_bar"
    t.integer   "min_price"
    t.integer   "capacity"
    t.integer   "min_duration"
  end

  create_table "sauna_photos", :force => true do |t|
    t.string    "description"
    t.integer   "sauna_id"
    t.string    "photo_file_name"
    t.integer   "photo_file_size"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sauna_types", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "saunas", :force => true do |t|
    t.string    "alias"
    t.string    "name"
    t.string    "phone_number1"
    t.string    "phone_number2"
    t.string    "phone_number3"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
    t.string    "email"
  end

  create_table "sms_messages", :force => true do |t|
    t.integer  "booking_id"
    t.string   "number"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "password_digest"
    t.integer   "user_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
