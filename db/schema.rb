# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101018070117) do

  create_table "activity_log", :force => true do |t|
    t.integer  "registration_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_log", ["registration_id"], :name => "index_activity_log_on_registration_id"

  create_table "ballot_styles", :force => true do |t|
    t.integer  "precinct_split_id", :null => false
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

  add_index "ballot_styles", ["precinct_split_id"], :name => "index_ballot_styles_on_precinct_split_id", :unique => true

  create_table "precinct_splits", :force => true do |t|
    t.integer "precinct_id"
    t.string  "name"
  end

  add_index "precinct_splits", ["precinct_id"], :name => "index_precinct_splits_on_precinct_id"

  create_table "precincts", :force => true do |t|
    t.string "name"
  end

  create_table "registrations", :force => true do |t|
    t.string   "name"
    t.string   "zip"
    t.string   "address"
    t.integer  "precinct_split_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.datetime "checked_in_at"
    t.string   "ssn4_hash"
  end

  add_index "registrations", ["checked_in_at"], :name => "index_registrations_on_checked_in_at"
  add_index "registrations", ["completed_at"], :name => "index_registrations_on_completed_at"
  add_index "registrations", ["name", "zip"], :name => "index_registrations_on_name_and_zip", :unique => true
  add_index "registrations", ["precinct_split_id"], :name => "index_registrations_on_precinct_split_id"
  add_index "registrations", ["ssn4_hash"], :name => "index_registrations_on_ssn4_hash"

end
