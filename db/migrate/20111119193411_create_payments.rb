class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
	  t.integer :booking_id					        
	  t.integer :price
	  t.text :description
	  t.string :status
      t.timestamps
    end  
  end
end
