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

ActiveRecord::Schema.define(version: 20180823094906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accommodations_schools", id: false, force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "accommodation_id", null: false
    t.index ["accommodation_id", "school_id"], name: "index_accommodations_schools_on_accommodation_id_and_school_id"
    t.index ["school_id", "accommodation_id"], name: "index_accommodations_schools_on_school_id_and_accommodation_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "image"
    t.boolean "is_promoted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "average_caches", id: :serial, force: :cascade do |t|
    t.integer "rater_id"
    t.string "rateable_type"
    t.integer "rateable_id"
    t.float "avg", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: :cascade do |t|
    t.string "picture"
    t.string "sound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_id"
    t.index ["test_id"], name: "index_cards_on_test_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "school_id"
    t.text "text"
    t.string "title"
    t.boolean "readed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commentable_id"
    t.string "commentable_type"
    t.index ["school_id"], name: "index_comments_on_school_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contact_us_messages", force: :cascade do |t|
    t.string "your_name"
    t.string "email"
    t.string "subject"
    t.string "custom_subj"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contact_us_messages_on_email"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "conversatable_type"
    t.string "conversatable_id"
  end

  create_table "core_especialities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "conversation_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nations", force: :cascade do |t|
    t.string "country"
    t.integer "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nationable_type"
    t.integer "nationable_id"
  end

  create_table "overall_averages", id: :serial, force: :cascade do |t|
    t.string "rateable_type"
    t.integer "rateable_id"
    t.float "overall_avg", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string "url"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", id: :serial, force: :cascade do |t|
    t.integer "rater_id"
    t.string "rateable_type"
    t.integer "rateable_id"
    t.float "stars", null: false
    t.string "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
    t.index ["rater_id"], name: "index_rates_on_rater_id"
  end

  create_table "rating_caches", id: :serial, force: :cascade do |t|
    t.string "cacheable_type"
    t.integer "cacheable_id"
    t.float "avg", null: false
    t.integer "qty", null: false
    t.string "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"
  end

  create_table "read_marks", id: :serial, force: :cascade do |t|
    t.string "readable_type", null: false
    t.integer "readable_id"
    t.string "reader_type", null: false
    t.integer "reader_id"
    t.datetime "timestamp"
    t.index ["readable_type", "readable_id"], name: "index_read_marks_on_readable_type_and_readable_id"
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true
    t.index ["reader_type", "reader_id"], name: "index_read_marks_on_reader_type_and_reader_id"
  end

  create_table "school_options", force: :cascade do |t|
    t.string "name"
    t.integer "type_id"
    t.boolean "active"
    t.bigint "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_school_options_on_school_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "title"
    t.string "short_description"
    t.text "description"
    t.boolean "is_active", default: false
    t.bigint "user_id"
    t.string "cover"
    t.json "media_attachments"
    t.string "country"
    t.string "city"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.integer "classes_from"
    t.integer "classes_to"
    t.text "additional_expenses"
    t.integer "study_period"
    t.text "discount_conditions"
    t.string "address"
    t.string "email"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_promoted", default: false
    t.index ["user_id"], name: "index_schools_on_user_id"
  end

  create_table "selected_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.index ["user_id", "card_id"], name: "index_selected_cards_on_user_id_and_card_id"
  end

  create_table "semesters", force: :cascade do |t|
    t.bigint "specialization_id"
    t.string "title"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialization_id"], name: "index_semesters_on_specialization_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.bigint "university_id"
    t.string "title"
    t.string "cover"
    t.string "level"
    t.string "join_season"
    t.string "language"
    t.string "passing_score"
    t.string "german_level"
    t.string "english_level"
    t.boolean "winter_term"
    t.boolean "summer_term"
    t.json "documents"
    t.json "entrance_workflow"
    t.json "entrance_exam"
    t.json "study_in_studienkolleg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "core_especiality_id"
    t.text "description", default: ""
    t.index ["university_id"], name: "index_specializations_on_university_id"
  end

  create_table "test_results", force: :cascade do |t|
    t.integer "attempts"
    t.integer "last_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "test_id"
    t.index ["test_id"], name: "index_test_results_on_test_id"
    t.index ["user_id"], name: "index_test_results_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.boolean "free"
    t.string "name"
    t.string "picture", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "universities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "short_description"
    t.text "description"
    t.string "university_type"
    t.string "address"
    t.string "city"
    t.string "country"
    t.string "website"
    t.string "cover"
    t.boolean "is_active", default: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.boolean "is_promoted", default: false
    t.integer "year_of_foundation"
    t.integer "students_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.json "media_attachments"
    t.string "email"
    t.index ["user_id"], name: "index_universities_on_user_id"
  end

  create_table "user_providers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_providers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "subscribe_ends"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "youtube_videos", force: :cascade do |t|
    t.string "url"
    t.string "thumb"
    t.string "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "embedable_type"
    t.integer "embedable_id"
  end

end
