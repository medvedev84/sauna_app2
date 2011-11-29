class SaunaComment < ActiveRecord::Base
  attr_accessible :user_name, :description
  belongs_to :sauna
end
