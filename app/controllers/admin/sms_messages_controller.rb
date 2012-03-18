class Admin::SmsMessagesController < AdminController
	include ApplicationHelper
	
	before_filter :admin_user
	
	def index 
		get_all_owners
		get_all_saunas
		
		h = params[:q]	
		@q = SmsMessage.search(h)									
		@current_page_number = params[:page] != nil ? params[:page] : 1 
		@sms_messages = @q.result(:distinct => true).order("created_at DESC").page(params[:page]).per(5)		
		
		respond_to do |format|
			format.html 
			format.js
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