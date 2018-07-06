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

ActiveRecord::Schema.define(version: 20180623171254) do

# Could not dump table "cards" because of following StandardError
#   Unknown type 'has_many' for column 'users'

  create_table "selected_cards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.index ["user_id", "card_id"], name: "index_selected_cards_on_user_id_and_card_id"
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

# Could not dump table "tests" because of following StandardError
#   Unknown type 'has_many' for column 'card'

# Could not dump table "users" because of following StandardError
#   Unknown type 'has_many' for column 'cards'

end
