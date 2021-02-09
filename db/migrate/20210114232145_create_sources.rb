class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.integer  :player_id
      t.boolean  :discarded
      t.string   :path
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
