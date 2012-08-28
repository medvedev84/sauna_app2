class District < ActiveRecord::Base
	attr_accessible :is_all, :name
	
	belongs_to :city
end
