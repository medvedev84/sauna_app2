class SiteSetting < ActiveRecord::Base
	number_regex = /^[\d]+([\d]+){0,1}$/
	number2_regex = /^[1-9]+[0-9]+$/
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :commission_fee, 	:presence => true, :length => { :maximum => 3 },  :format => { :with => number2_regex }	
	validates :booking_fee,		:presence => true, :length => { :maximum => 4 },  :format => { :with => number2_regex }		
	validates :phone_number, 	:presence => true, :length => { :maximum => 11 }, :format => { :with => number_regex }		
	validates :email, 			:presence => true, :format => { :with => email_regex }         
					
	def self.get_commission_fee
		SiteSetting.find(1).commission_fee
	end  	
	
	def self.get_booking_fee
		SiteSetting.find(1).booking_fee
	end  

	def self.get_phone_number
		SiteSetting.find(1).phone_number
	end  

	def self.get_email
		SiteSetting.find(1).email
	end  	
end