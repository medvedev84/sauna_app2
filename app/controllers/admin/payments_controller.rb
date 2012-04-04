class Admin::PaymentsController < AdminController
	include ApplicationHelper
		
	before_filter :authenticate
	
	def index 
		get_all_owners
		get_all_saunas
		
		h = params[:q]
		@q = Payment.search(h)									
		@current_page_number = params[:page] != nil ? params[:page] : 1 
		@payments = @q.result(:distinct => true).page(params[:page]).per(10)	
		
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