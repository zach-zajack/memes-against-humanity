class CreateMemes < ActiveRecord::Migration[5.2]
  def change
    create_table :memes do |t|
      t.integer :player_id
      t.integer :round_id
      t.string  :path
      
      t.timestamps
    end
  end
end
