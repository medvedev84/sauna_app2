class CreateInternalPayments < ActiveRecord::Migration
  def change
    create_table :internal_payments do |t|
	  t.integer :payment_id			
	  t.integer :user_id			  
	  t.integer :amount
      t.timestamps
    end  
  end
end
