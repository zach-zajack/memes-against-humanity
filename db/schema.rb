# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_21_225210) do

  create_table "games", force: :cascade do |t|
    t.integer "join_code"
    t.boolean "playing", default: false
    t.integer "max_score", default: 10
    t.integer "source_count", default: 7
    t.boolean "join_midgame", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memes", force: :cascade do |t|
    t.integer "round_id"
    t.integer "player_id"
    t.integer "source1_id"
    t.integer "source2_id"
    t.integer "source3_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "player_id"
    t.integer "game_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.integer "score", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "game_id"
    t.integer "czar_id"
    t.integer "winner_id"
    t.integer "template_id"
    t.integer "shuffle_seed"
    t.boolean "judging", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.integer "player_id"
    t.boolean "discarded"
    t.string "path"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.integer "round_id"
    t.string "key"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
