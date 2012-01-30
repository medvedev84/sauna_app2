class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.integer :city_id
	  t.boolean :is_all
      t.timestamps
    end
  end
end
