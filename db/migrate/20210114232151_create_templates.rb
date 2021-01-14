class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.integer :round_id
      t.string  :path
      t.integer :slots
      
      t.timestamps
    end
  end
end
