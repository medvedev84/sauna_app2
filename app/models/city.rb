class City < ActiveRecord::Base
  has_one :address
  has_many  :districts
  has_many  :coupon_url
end
