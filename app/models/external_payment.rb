class ExternalPayment < ActiveRecord::Base
	belongs_to :user  

	#constants
	INIT = 1
	APPROVE = 2
	DECLINE = 3
  
	number_regex = /^[\d]+([\d]+){0,1}$/
	validates :amount, :presence => true, :length   => { :maximum => 11 }, :format   => { :with => number_regex }	
	validates :ps_trans_id, :presence => true
	
	def self.init 
		INIT
	end
	
	def self.approve 
		APPROVE
	end
	
	def self.decline 
		DECLINE
	end	
end