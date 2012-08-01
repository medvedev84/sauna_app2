class CreateCouponDeals < ActiveRecord::Migration
  def change
    create_table :coupon_deals do |t|
	  t.integer :coupon_url_id			
	  t.string :description
	  t.string :deal_url
	  t.string :image_url	  
	  t.string :price_old	  
	  t.string :price_new	  
      t.timestamps
    end  
  end
end

