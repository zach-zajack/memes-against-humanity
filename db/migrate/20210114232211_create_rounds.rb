class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.integer  :game_id
      t.integer  :czar_id
      t.integer  :winner_id
      t.integer  :template_id
      t.integer  :shuffle_seed
      t.boolean  :judging, default: false
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
