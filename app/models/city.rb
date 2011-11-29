class City < ActiveRecord::Base
  has_one :address
end
