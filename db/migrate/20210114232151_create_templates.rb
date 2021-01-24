class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.integer :round_id
      t.string  :key

      t.timestamps
    end
  end
end
