class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
	  t.integer :booking_id					        
	  t.string :phone_number	  
	  t.string :sms_number
	  t.text :message_text 
	  t.string :status
      t.timestamps
    end  
  end
end
