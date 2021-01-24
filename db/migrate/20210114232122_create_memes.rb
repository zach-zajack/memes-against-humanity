class CreateMemes < ActiveRecord::Migration[5.2]
  def change
    create_table :memes do |t|
      t.integer :round_id
      t.integer :player_id
      t.integer :source1_id
      t.integer :source2_id
      t.integer :source3_id

      t.timestamps
    end
  end
end
