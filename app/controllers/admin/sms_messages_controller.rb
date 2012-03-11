class Admin::SmsMessagesController < ApplicationController
	include SmsMessagesHelper
	
	before_filter :admin_user
	
	def index 
		get_all_owners
		get_all_saunas
		
		h = params[:q]
		if h != nil					
			@q = SmsMessage.search(h)					
			@sms_messages = @q.result(:distinct => true)							
		else		
			@q = SmsMessage.search(h)								
			@sms_messages = Array.new # return empty array if visit index page at the first time
		end
	end
	
	private

	def admin_user
		if !current_user.super_admin? 
			flash[:error] = :access_denied
			redirect_to('/incorrect') 			
		end
	end		
end