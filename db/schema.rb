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

ActiveRecord::Schema.define(:version => 20130215073758) do

  create_table "categories", :force => true do |t|
    t.integer  "category_parent_id",   :default => 0, :null => false
    t.string   "category_name"
    t.integer  "category_status",                     :null => false
    t.string   "category_url_name"
    t.string   "category_description"
    t.string   "category_image"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_repeats", :force => true do |t|
    t.integer  "event_id",                              :null => false
    t.integer  "daily"
    t.integer  "daily_repeat_day"
    t.datetime "daily_end_date"
    t.integer  "weekly"
    t.integer  "weekly_repeat_week"
    t.integer  "weekly_repeat_day"
    t.datetime "weekly_end_date"
    t.integer  "monthly"
    t.integer  "monthly_repeat_on"
    t.integer  "monthly_repeat_day"
    t.integer  "monthly_repeat_day_num"
    t.integer  "monthly_repeat_months"
    t.datetime "monthly_end_date"
    t.integer  "other_specific"
    t.datetime "spec_start_date"
    t.datetime "spec_end_date"
    t.integer  "spec_display_end_date"
    t.string   "your_date",              :limit => 355
    t.text     "your_date_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_themes", :force => true do |t|
    t.integer  "event_id",                          :null => false
    t.integer  "theme_id",                          :null => false
    t.string   "event_title",         :limit => 30, :null => false
    t.string   "background",          :limit => 30, :null => false
    t.string   "header_text",         :limit => 30, :null => false
    t.string   "box_background",      :limit => 30, :null => false
    t.string   "body_text",           :limit => 30, :null => false
    t.string   "box_border",          :limit => 30, :null => false
    t.string   "links",               :limit => 30, :null => false
    t.string   "box_header",          :limit => 30, :null => false
    t.text     "header_text_display"
    t.text     "footer_text_display"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",                              :null => false
    t.string   "event_title",                          :null => false
    t.string   "vanue_name",                           :null => false
    t.text     "street_address",                       :null => false
    t.integer  "online_event_option"
    t.integer  "show_on_map"
    t.datetime "event_start_date_time",                :null => false
    t.datetime "event_end_date_time",                  :null => false
    t.integer  "display_start_time"
    t.integer  "display_end_time"
    t.integer  "event_repeat"
    t.text     "event_repeat_text"
    t.string   "event_logo",                           :null => false
    t.text     "event_detail",                         :null => false
    t.string   "organizer_host",                       :null => false
    t.text     "host_description",                     :null => false
    t.integer  "add_social_link"
    t.integer  "add_facebook"
    t.string   "facebook_link",         :limit => 355
    t.integer  "add_twitter"
    t.string   "twitter_link",          :limit => 355
    t.integer  "keep_private"
    t.integer  "share_on_social"
    t.integer  "invite_only"
    t.integer  "password_protect"
    t.string   "password_value",        :limit => 25
    t.integer  "category"
    t.integer  "subcategory"
    t.integer  "remaining_tickets"
    t.string   "event_url_link",        :limit => 355
    t.integer  "event_capacity"
    t.integer  "event_pass_fees"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_time_zone"
    t.integer  "display_time_zone"
    t.integer  "organizer_id"
  end

  create_table "organizers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "site_settings", :force => true do |t|
    t.integer  "site_online",                                                       :default => 1, :null => false
    t.integer  "captcha_enable",                                                    :default => 0, :null => false
    t.string   "site_name"
    t.string   "site_version"
    t.string   "site_language"
    t.string   "currency_symbol"
    t.string   "currency_code"
    t.string   "currency_symbol_side", :limit => 50,                                               :null => false
    t.integer  "decimal_points",                                                                   :null => false
    t.string   "date_format"
    t.string   "time_format"
    t.string   "date_time_format"
    t.string   "site_tracker"
    t.string   "robots"
    t.string   "how_it_works_video"
    t.integer  "zipcode_min",                                                       :default => 4, :null => false
    t.integer  "zipcode_max",                                                       :default => 8, :null => false
    t.string   "site_timezone"
    t.string   "google_map_key"
    t.string   "default_longitude"
    t.string   "default_latitude"
    t.text     "site_video"
    t.decimal  "paid_ticket_fee",                    :precision => 10, :scale => 2,                :null => false
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "event_start_day"
    t.integer  "event_end_day"
    t.integer  "max_purchase_allowed"
    t.integer  "min_purchase_allowed"
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "event_title",    :limit => 30, :null => false
    t.string   "background",     :limit => 30, :null => false
    t.string   "header_text",    :limit => 30, :null => false
    t.string   "box_background", :limit => 30, :null => false
    t.string   "body_text",      :limit => 30, :null => false
    t.string   "box_border",     :limit => 30, :null => false
    t.string   "links",          :limit => 30, :null => false
    t.string   "box_header",     :limit => 30, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "ticket_statuses", :force => true do |t|
    t.string   "status_name", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tickets", :force => true do |t|
    t.integer  "event_id",                  :null => false
    t.integer  "free",                      :null => false
    t.string   "free_ticket_name"
    t.integer  "free_qty"
    t.integer  "free_ticket_status"
    t.datetime "free_start_sale"
    t.datetime "free_end_sale"
    t.integer  "free_min_purchase"
    t.integer  "free_max_purchase"
    t.text     "free_description",          :null => false
    t.integer  "free_hide_description"
    t.integer  "paid"
    t.string   "paid_ticket_name"
    t.integer  "paid_qty"
    t.integer  "paid_price"
    t.integer  "paid_buyer_total"
    t.integer  "paid_ticket_status"
    t.integer  "paid_fee"
    t.datetime "paid_start_sale"
    t.datetime "paid_end_sale"
    t.integer  "paid_min_purchase"
    t.integer  "paid_max_purchase"
    t.text     "paid_description"
    t.integer  "paid_service_fee"
    t.integer  "paid_hide_description"
    t.integer  "donation"
    t.integer  "donation_ticket_name"
    t.integer  "donation_qty"
    t.integer  "donation_price"
    t.integer  "donation_fee"
    t.integer  "donation_buyer_total"
    t.integer  "donation_start_sale"
    t.integer  "donation_end_sale"
    t.integer  "donation_min_purchase"
    t.integer  "donation_max_purchase"
    t.text     "donation_description"
    t.integer  "donation_service_fee"
    t.integer  "donation_hide_description"
    t.integer  "donation_ticket_status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "timezones", :force => true do |t|
    t.string   "tz"
    t.text     "gmt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "prefix"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "suffix"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "email"
    t.string   "salt"
    t.string   "hashed_password"
  end

end
