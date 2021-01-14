class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :join_code
      t.boolean :playing,      default: false
      t.integer :max_score,    default: 10
      t.boolean :join_midgame, default: false

      t.timestamps
    end
  end
end
