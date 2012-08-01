class CreateCouponUrls < ActiveRecord::Migration
  def change
    create_table :coupon_urls do |t|
	  t.integer :city_id				  
	  t.string :site_url
	  t.string :name 
      t.timestamps
    end  
  end
end

