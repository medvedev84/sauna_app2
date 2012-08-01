class CouponUrl < ActiveRecord::Base
  belongs_to :city  	
  has_many  :coupon_deal  
end