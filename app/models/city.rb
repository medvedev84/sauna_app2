class City < ActiveRecord::Base
  has_one :address
  has_many  :districts
end
