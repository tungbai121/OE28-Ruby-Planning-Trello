# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_05_161526) do

  create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "action"
    t.bigint "user_id", null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_activities_on_board_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "annoucements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "content"
    t.boolean "readed", default: false
    t.integer "annoucementable_id"
    t.string "annoucementable_type"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["annoucementable_type", "annoucementable_id"], name: "annoucement_polymorphic"
    t.index ["user_id"], name: "index_annoucements_on_user_id"
  end

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "attachmentable_id"
    t.string "attachmentable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "boards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "status"
    t.boolean "closed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "card_labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "label_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id", "label_id"], name: "index_card_labels_on_card_id_and_label_id", unique: true
    t.index ["card_id"], name: "index_card_labels_on_card_id"
    t.index ["label_id"], name: "index_card_labels_on_label_id"
  end

  create_table "card_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id", "user_id"], name: "index_card_users_on_card_id_and_user_id", unique: true
    t.index ["card_id"], name: "index_card_users_on_card_id"
    t.index ["user_id"], name: "index_card_users_on_user_id"
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "position"
    t.datetime "deadline"
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.boolean "closed", default: false
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_cards_on_list_id"
  end

  create_table "checklists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "checked", default: false
    t.bigint "card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_checklists_on_card_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "content"
    t.bigint "card_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_comments_on_card_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "content"
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_labels_on_board_id"
  end

  create_table "lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.boolean "closed", default: false
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_lists_on_board_id"
  end

  create_table "user_boards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "role_id"
    t.boolean "starred", default: false
    t.bigint "user_id", null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_user_boards_on_board_id"
    t.index ["user_id", "board_id"], name: "index_user_boards_on_user_id_and_board_id", unique: true
    t.index ["user_id"], name: "index_user_boards_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin", default: false
    t.boolean "blocked", default: false
    t.string "avatar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "activities", "boards"
  add_foreign_key "activities", "users"
  add_foreign_key "card_labels", "cards"
  add_foreign_key "card_labels", "labels"
  add_foreign_key "card_users", "cards"
  add_foreign_key "card_users", "users"
  add_foreign_key "cards", "lists"
  add_foreign_key "checklists", "cards"
  add_foreign_key "comments", "cards"
  add_foreign_key "comments", "users"
  add_foreign_key "labels", "boards"
  add_foreign_key "lists", "boards"
  add_foreign_key "user_boards", "boards"
  add_foreign_key "user_boards", "users"
end
