class CreateExternalPayments < ActiveRecord::Migration
  def change
    create_table :external_payments do |t|
	  t.integer :payment_id			
	  t.integer :user_id			  
	  t.integer :amount
	  t.string :status	  
	  t.string :ps_name
	  t.string :ps_order_id	
	  t.string :ps_trans_id	
      t.timestamps
    end  
  end
end
