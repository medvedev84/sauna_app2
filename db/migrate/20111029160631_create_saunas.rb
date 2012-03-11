class CreateSaunas < ActiveRecord::Migration
  def change
    create_table :saunas do |t|
      t.string :name
      t.string :phone_number1
      t.string :phone_number2
      t.string :phone_number3
	  t.string :alias
	  t.boolean :is_booking

      t.timestamps
    end
  end
end
