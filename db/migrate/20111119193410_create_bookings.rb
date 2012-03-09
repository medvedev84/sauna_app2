class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :fio
      t.datetime :starts_at
      t.datetime :ends_at     
      t.text :description
	  t.string :phone_number
	  t.string :email
	  t.integer :sauna_id
      t.timestamps
    end  
  end
end
