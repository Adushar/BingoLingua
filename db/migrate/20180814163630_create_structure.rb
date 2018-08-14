class CreateStructure < ActiveRecord::Migration[5.1]
  def change
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

    create_table "cards", force: :cascade do |t|
      t.string "picture"
      t.string "sound"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "test_id"
      t.index ["test_id"], name: "index_cards_on_test_id"
    end

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
    #   Unknown type 'has_many' for column 'cards'

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
  end
end
