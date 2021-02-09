class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer  :join_code
      t.boolean  :playing,      default: false
      t.integer  :max_score,    default: 10
      t.integer  :source_count, default: 7
      t.boolean  :join_midgame, default: false
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
