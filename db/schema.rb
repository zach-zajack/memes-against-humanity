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

ActiveRecord::Schema.define(version: 2021_01_21_225210) do

  create_table "games", force: :cascade do |t|
    t.integer "join_code"
    t.boolean "playing", default: false
    t.integer "max_score", default: 10
    t.integer "source_count", default: 7
    t.boolean "join_midgame", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memes", force: :cascade do |t|
    t.integer "round_id"
    t.integer "source1_id"
    t.integer "source2_id"
    t.integer "source3_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.integer "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "game_id"
    t.integer "czar_id"
    t.integer "winner_id"
    t.integer "template_id"
    t.boolean "judging", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.integer "player_id"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.integer "round_id"
    t.string "base"
    t.string "overlay"
    t.integer "slots"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
