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

ActiveRecord::Schema.define(:version => 20120507173820) do

  create_table "addresses", :force => true do |t|
    t.integer   "sauna_id"
    t.integer   "city_id"
    t.integer   "district_id"
    t.string    "street"
    t.string    "building"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "advertisements", :force => true do |t|
    t.integer   "photo_file_size"
    t.string    "photo_file_name"
    t.integer   "city_id"
    t.string    "company_name"
    t.string    "phone_number"
    t.string    "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.boolean   "is_canceled"
    t.integer   "sauna_item_id"
    t.string    "email"
    t.string    "phone_number"
    t.string    "fio"
    t.timestamp "starts_at"
    t.timestamp "ends_at"
    t.string    "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "coupon_deals", :force => true do |t|
    t.integer  "coupon_url_id"
    t.string   "description"
    t.string   "deal_url"
    t.string   "image_url"
    t.string   "price_old"
    t.string   "price_new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_urls", :force => true do |t|
    t.string   "partner_url"
    t.integer  "city_id"
    t.string   "site_url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.boolean   "is_all"
    t.string    "name"
    t.integer   "city_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "external_payments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "amount"
    t.integer   "status"
    t.string    "ps_name"
    t.string    "ps_order_id"
    t.string    "ps_trans_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "internal_payments", :force => true do |t|
    t.integer   "external_payment_id"
    t.integer   "payment_id"
    t.integer   "user_id"
    t.integer   "amount"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "internal_transactions", :force => true do |t|
    t.integer   "external_payment_id"
    t.integer   "payment_id"
    t.integer   "user_id"
    t.integer   "amount"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.string    "ps_order_id"
    t.string    "ps_name"
    t.integer   "booking_id"
    t.integer   "amount"
    t.text      "description"
    t.integer   "status"
    t.timestamp "created_at"
    t.timestamp "updated_at"
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
    t.boolean   "is_booking"
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

  create_table "simple_captcha_data", :force => true do |t|
    t.string    "key",        :limit => 40
    t.string    "value",      :limit => 6
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "site_settings", :force => true do |t|
    t.string    "email"
    t.string    "phone_number"
    t.integer   "booking_fee"
    t.integer   "commission_fee"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sms_messages", :force => true do |t|
    t.text      "message_text"
    t.string    "phone_number"
    t.integer   "booking_id"
    t.string    "sms_number"
    t.string    "status"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "wmr_purse"
    t.integer   "balance_amount"
    t.string    "name"
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "password_digest"
    t.integer   "user_type"
  end

end
