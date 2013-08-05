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

ActiveRecord::Schema.define(:version => 20130510005831) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "alarm_configs", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "court"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "alarms", :force => true do |t|
    t.string   "name"
    t.string   "content"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "count"
  end

  create_table "businesses", :force => true do |t|
    t.string   "sales_area"
    t.integer  "worker_number_of_this_year"
    t.integer  "worker_number_of_last_year"
    t.integer  "worker_number_of_the_year_before_last"
    t.float    "income_of_this_year"
    t.float    "income_of_last_year"
    t.float    "income_of_the_year_before_last"
    t.float    "assets_of_this_year"
    t.float    "assets_of_last_year"
    t.float    "assets_of_the_year_before_last"
    t.float    "debt_of_this_year"
    t.float    "debt_of_last_year"
    t.float    "debt_of_the_year_before_last"
    t.float    "profit_of_this_year"
    t.float    "profit_of_last_year"
    t.float    "profit_of_the_year_before_last"
    t.float    "order_amount_of_this_year"
    t.float    "order_amount_of_last_year"
    t.float    "order_amount_of_the_year_before_last"
    t.float    "vat_of_this_year"
    t.float    "vat_of_last_year"
    t.float    "vat_of_the_year_before_last"
    t.float    "income_tax_of_this_year"
    t.float    "income_tax_of_last_year"
    t.float    "income_tax_of_the_year_before_last"
    t.float    "elec_charges_monthly_of_this_year"
    t.float    "elec_charges_monthly_of_last_year"
    t.float    "elec_charges_monthly_of_the_year_before_last"
    t.float    "water_charges_monthly_of_this_year"
    t.float    "water_charges_monthly_of_last_year"
    t.float    "water_charges_monthly_of_the_year_before_last"
    t.float    "major_income_of_this_year"
    t.float    "major_income_of_last_year"
    t.float    "major_income_of_the_year_before_last"
    t.integer  "company_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "scale"
    t.integer  "sales"
    t.integer  "profit"
    t.integer  "credit"
  end

  create_table "capabilities", :force => true do |t|
    t.text     "can",        :null => false
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "capabilities", ["role_id"], :name => "index_capabilities_on_role_id"
  add_index "capabilities", ["user_id"], :name => "index_capabilities_on_user_id"

  create_table "certs", :force => true do |t|
    t.string   "regist_id"
    t.string   "name"
    t.string   "address"
    t.string   "owner_name"
    t.string   "regist_capital"
    t.string   "paid_in_capital"
    t.string   "company_type"
    t.string   "found_date"
    t.string   "business_scope"
    t.string   "business_start_date"
    t.string   "business_end_date"
    t.string   "regist_org"
    t.string   "approved_date"
    t.string   "check_years"
    t.integer  "company_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "snapshot_path"
    t.text     "orig_url"
    t.datetime "snapshot_at"
    t.float    "regist_capital_amount"
  end

  add_index "certs", ["company_id"], :name => "index_certs_on_company_id", :unique => true

  create_table "client_company_relationships", :force => true do |t|
    t.integer  "client_id"
    t.string   "client_type"
    t.integer  "company_id"
    t.text     "desc"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "relate_type",     :null => false
    t.float    "hold_percent"
    t.date     "start_date"
    t.date     "expiration_date"
    t.integer  "importer_id"
  end

  add_index "client_company_relationships", ["client_id", "client_type"], :name => "index_client_company_relationships_on_client_id_and_client_type"

  create_table "client_person_relationships", :force => true do |t|
    t.integer  "client_id"
    t.string   "client_type"
    t.integer  "person_id"
    t.string   "person_name"
    t.string   "person_number"
    t.text     "desc"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "relate_type",     :null => false
    t.float    "hold_percent"
    t.date     "start_date"
    t.date     "expiration_date"
    t.integer  "importer_id"
  end

  add_index "client_person_relationships", ["client_id", "client_type"], :name => "index_client_person_relationships_on_client_id_and_client_type"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.boolean  "idinfo_crawled",                            :default => false
    t.boolean  "court_crawled",                             :default => false
    t.boolean  "water_crawled",                             :default => false
    t.boolean  "power_crawled",                             :default => false
    t.boolean  "sentiment_crawled",                         :default => false
    t.integer  "owner_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "owner_name"
    t.string   "idinfo_status"
    t.integer  "court_status",                              :default => 0
    t.string   "water_status"
    t.string   "power_status"
    t.string   "sentiment_status"
    t.string   "code"
    t.integer  "create_way",                                :default => 0
    t.string   "region_code",                  :limit => 8
    t.integer  "industry_id"
    t.integer  "water_company_accounts_count",              :default => 0
    t.integer  "elec_company_accounts_count",               :default => 0
    t.integer  "crimes_count"
    t.integer  "importer_id"
  end

  add_index "companies", ["court_status"], :name => "index_companies_on_court_status"
  add_index "companies", ["industry_id"], :name => "index_companies_on_industry_id"
  add_index "companies", ["name"], :name => "index_companies_on_name", :unique => true
  add_index "companies", ["number"], :name => "index_companies_on_number"
  add_index "companies", ["owner_id"], :name => "index_companies_on_owner_id"
  add_index "companies", ["region_code"], :name => "index_companies_on_region_code"

  create_table "company_clients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "importer_id"
  end

  add_index "company_clients", ["user_id"], :name => "index_company_clients_on_user_id"

  create_table "company_crimes", :force => true do |t|
    t.integer "company_id"
    t.integer "crime_id"
  end

  add_index "company_crimes", ["company_id"], :name => "index_company_crimes_on_company_id"

  create_table "credits", :force => true do |t|
    t.integer  "company_id"
    t.string   "reg_address"
    t.string   "reg_zip"
    t.string   "opt_address"
    t.string   "opt_zip"
    t.string   "zone"
    t.string   "industry"
    t.string   "tel"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "main_product"
    t.string   "sales_region"
    t.string   "clients_type"
    t.string   "upstream"
    t.string   "downstream"
    t.string   "opt_stage"
    t.integer  "epl_count"
    t.integer  "master"
    t.integer  "bachelor"
    t.integer  "junior"
    t.integer  "other"
    t.float    "self_area"
    t.float    "self_head"
    t.float    "self_branch"
    t.float    "self_value"
    t.float    "rent_area"
    t.float    "rent_head"
    t.float    "rent_branch"
    t.float    "rent_value"
    t.float    "mort_area"
    t.float    "mort_head"
    t.float    "mort_branch"
    t.float    "mort_value"
    t.string   "bank_name"
    t.string   "bank_account"
    t.string   "bank_address"
    t.string   "bank_tel"
    t.integer  "avg_digits"
    t.string   "bank_level"
    t.boolean  "bad_cert"
    t.boolean  "bad_tax"
    t.boolean  "bad_social"
    t.boolean  "bad_trade"
    t.boolean  "involved_before"
    t.boolean  "bad_manage"
    t.boolean  "bad_court"
    t.text     "industry_review"
    t.float    "gross_profit_0"
    t.float    "ratio_return_0"
    t.float    "ratio_profit_0"
    t.float    "ratio_net_return_0"
    t.float    "ratio_asset_liability_0"
    t.float    "ratio_liquidity_0"
    t.float    "ratio_quick_0"
    t.float    "ratio_ar_0"
    t.float    "ratio_inventory_0"
    t.float    "ratio_assets_0"
    t.float    "gross_profit_1"
    t.float    "ratio_return_1"
    t.float    "ratio_profit_1"
    t.float    "ratio_net_return_1"
    t.float    "ratio_asset_liability_1"
    t.float    "ratio_liquidity_1"
    t.float    "ratio_quick_1"
    t.float    "ratio_ar_1"
    t.float    "ratio_inventory_1"
    t.float    "ratio_assets_1"
    t.float    "gross_profit_2"
    t.float    "ratio_return_2"
    t.float    "ratio_profit_2"
    t.float    "ratio_net_return_2"
    t.float    "ratio_asset_liability_2"
    t.float    "ratio_liquidity_2"
    t.float    "ratio_quick_2"
    t.float    "ratio_ar_2"
    t.float    "ratio_inventory_2"
    t.float    "ratio_assets_2"
    t.string   "credit_lvl"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "crimes", :force => true do |t|
    t.string   "party_name"
    t.string   "party_number"
    t.string   "case_id"
    t.string   "case_state"
    t.string   "reg_date"
    t.float    "apply_money"
    t.string   "court_name"
    t.integer  "party_id"
    t.string   "party_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "orig_url"
    t.string   "snapshot_path"
    t.date     "regist_date"
    t.datetime "snapshot_at"
    t.integer  "state"
  end

  add_index "crimes", ["party_id", "party_type"], :name => "index_crimes_on_party_id_and_party_type"

  create_table "equips", :force => true do |t|
    t.integer  "credit_id"
    t.string   "name"
    t.string   "count"
    t.string   "tech"
    t.string   "memo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "exporters", :force => true do |t|
    t.integer  "user_id"
    t.string   "format"
    t.string   "file_path"
    t.text     "options"
    t.string   "content_type"
    t.integer  "status",       :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "exports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category"
    t.string   "response_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "options"
  end

  create_table "holder_changes", :force => true do |t|
    t.integer  "credit_id"
    t.date     "change_at"
    t.string   "name"
    t.float    "before_amount"
    t.float    "before_percent"
    t.float    "after_amount"
    t.float    "after_percent"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "importer_exception_temps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "importer_id"
    t.text     "data",                         :null => false
    t.string   "exception_msg"
    t.integer  "status",        :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "importers", :force => true do |t|
    t.integer  "status"
    t.integer  "importable_id"
    t.string   "importable_type"
    t.integer  "user_id"
    t.string   "name"
    t.string   "file"
    t.string   "type"
    t.string   "error_message"
    t.string   "progress"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "view_status",     :default => 1
    t.string   "process_bar"
  end

  create_table "industries", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "logo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "list_files", :force => true do |t|
    t.integer  "user_id"
    t.string   "clients_list"
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "import_status", :default => 0
  end

  add_index "list_files", ["import_status"], :name => "index_list_files_on_import_status"
  add_index "list_files", ["user_id"], :name => "index_list_files_on_user_id"

  create_table "loans", :force => true do |t|
    t.integer  "credit_id"
    t.string   "name"
    t.string   "category"
    t.float    "amount"
    t.integer  "due_time"
    t.date     "deadline"
    t.float    "balance"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mass_changes", :force => true do |t|
    t.integer  "credit_id"
    t.date     "change_at"
    t.string   "event"
    t.string   "before"
    t.string   "after"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "recipient_id",                    :null => false
    t.integer  "event_id"
    t.string   "event_type"
    t.boolean  "read",         :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"

  create_table "morts", :force => true do |t|
    t.integer  "credit_id"
    t.string   "name"
    t.string   "category"
    t.float    "amount"
    t.integer  "due_time"
    t.date     "deadline"
    t.float    "balance"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notices", :force => true do |t|
    t.string   "subject_id"
    t.string   "subject_type"
    t.text     "carriage"
    t.string   "type",                              :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "sent_to_apollo", :default => false
  end

  add_index "notices", ["subject_id", "subject_type"], :name => "index_notices_on_subject_id_and_subject_type"

  create_table "operators", :force => true do |t|
    t.integer  "credit_id"
    t.string   "category"
    t.string   "name"
    t.string   "sex"
    t.date     "birthday"
    t.string   "number"
    t.string   "education"
    t.string   "position"
    t.string   "address"
    t.string   "zip"
    t.text     "cv"
    t.string   "negative"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.boolean  "court_crawled",     :default => false
    t.boolean  "idinfo_crawled",    :default => false
    t.boolean  "sentiment_crawled", :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "idinfo_status"
    t.integer  "court_status",      :default => 0
    t.string   "sentiment_status"
    t.integer  "crimes_count"
  end

  add_index "people", ["court_status"], :name => "index_people_on_court_status"
  add_index "people", ["number"], :name => "index_people_on_number", :unique => true

  create_table "person_clients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "person_clients", ["user_id"], :name => "index_person_clients_on_user_id"

  create_table "person_crimes", :force => true do |t|
    t.integer "person_id"
    t.integer "crime_id"
  end

  add_index "person_crimes", ["person_id"], :name => "index_person_crimes_on_person_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "seeks", :force => true do |t|
    t.string   "company_name"
    t.string   "company_number"
    t.string   "person_name"
    t.string   "person_number"
    t.boolean  "crawled",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "skyeye_apollo_apollo_businesses", :force => true do |t|
    t.integer  "company_id",                      :null => false
    t.integer  "order_status", :default => 0
    t.boolean  "black",        :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "custinfoid"
  end

  add_index "skyeye_apollo_apollo_businesses", ["company_id"], :name => "index_skyeye_apollo_apollo_businesses_on_company_id"
  add_index "skyeye_apollo_apollo_businesses", ["custinfoid"], :name => "index_skyeye_apollo_apollo_businesses_on_custinfoid"

  create_table "skyeye_power_bills", :force => true do |t|
    t.decimal  "amount",                :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "cost",                  :precision => 8, :scale => 2, :default => 0.0
    t.datetime "record_time"
    t.boolean  "paid"
    t.string   "last_number"
    t.string   "this_number"
    t.integer  "company_id"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.integer  "company_account_id"
    t.string   "importer_secure_token"
  end

  create_table "skyeye_power_company_accounts", :force => true do |t|
    t.integer  "company_id"
    t.string   "type"
    t.string   "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "water_number"
    t.string   "elec_number"
    t.integer  "author_id"
    t.string   "importer_secure_token"
  end

  create_table "spiders", :force => true do |t|
    t.integer  "sponsor_id"
    t.string   "sponsor_type"
    t.integer  "status",          :default => 0
    t.text     "data"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "type"
    t.datetime "last_crawled_at"
  end

  add_index "spiders", ["sponsor_id", "sponsor_type"], :name => "index_spiders_on_sponsor_id_and_sponsor_type"
  add_index "spiders", ["status"], :name => "index_spiders_on_status"

  create_table "statistic_clients", :force => true do |t|
    t.string   "micro"
    t.integer  "user_id",                                 :null => false
    t.string   "region_code"
    t.integer  "company",                  :default => 0
    t.integer  "company_court",            :default => 0
    t.integer  "company_court_ok",         :default => 0
    t.integer  "company_court_closed",     :default => 0
    t.integer  "company_court_stopped",    :default => 0
    t.integer  "company_court_other",      :default => 0
    t.integer  "company_court_processing", :default => 0
    t.integer  "seek",                     :default => 0
    t.datetime "from_at"
    t.datetime "to_at"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "user_plugins", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "plugin_name", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_plugins", ["plugin_name"], :name => "index_user_plugins_on_plugin_name"

  create_table "user_seeks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "seek_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_seeks", ["user_id"], :name => "index_user_seeks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "role_id"
    t.integer  "institution_id"
    t.integer  "unread_messages_count",  :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workflow_statuses", :force => true do |t|
    t.string   "name",        :limit => 30, :default => "",       :null => false
    t.boolean  "is_closed",                 :default => false,    :null => false
    t.boolean  "is_default",                :default => false,    :null => false
    t.string   "html_color",  :limit => 6,  :default => "FFFFFF", :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "description"
    t.integer  "position"
    t.integer  "tracker_id"
  end

  create_table "workflow_traces", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "tracker_id"
    t.integer  "status_id"
    t.integer  "assigned_to_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "workflow_trackers", :force => true do |t|
    t.string   "name",        :limit => 30, :default => "",    :null => false
    t.boolean  "is_in_chlog",               :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "description"
  end

  create_table "workflow_workflows", :force => true do |t|
    t.integer  "tracker_id",    :default => 0,     :null => false
    t.integer  "old_status_id", :default => 0,     :null => false
    t.integer  "new_status_id", :default => 0,     :null => false
    t.integer  "role_id",       :default => 0,     :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "assignee",      :default => false, :null => false
    t.boolean  "author",        :default => false, :null => false
  end

end
