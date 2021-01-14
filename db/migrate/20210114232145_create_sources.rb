class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.integer :player_id
      t.string  :path
      t.integer :order, default: -1
      t.boolean :hidden, default: false
      
      t.timestamps
    end
  end
end
