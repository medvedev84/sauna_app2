class District < ActiveRecord::Base
	attr_accessible :is_all
	
	belongs_to :city
end
