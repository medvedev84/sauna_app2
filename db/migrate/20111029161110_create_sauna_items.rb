class CreateSaunaItems < ActiveRecord::Migration
  def change
    create_table :sauna_items do |t|
      t.string :name
      t.integer :sauna_id

      t.timestamps
    end
  end
end
