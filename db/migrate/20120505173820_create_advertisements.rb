class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
	  t.integer :city_id			
	  t.string :company_name
	  t.string :phone_number
	  t.string :description	  
      t.timestamps
    end  
  end
end

