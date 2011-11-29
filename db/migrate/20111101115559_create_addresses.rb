class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :city_id
      t.integer :district_id
      t.string :street
      t.string :building
      t.integer :sauna_id

      t.timestamps
    end
  end
end
