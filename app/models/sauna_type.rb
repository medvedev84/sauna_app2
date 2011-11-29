class SaunaType < ActiveRecord::Base
  has_one :sauna_item
end
