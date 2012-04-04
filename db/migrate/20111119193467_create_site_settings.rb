class CreateSiteSettings < ActiveRecord::Migration
  def change
    create_table :site_settings do |t|
	  t.integer :commission_fee			
      t.timestamps
    end  
  end
end
