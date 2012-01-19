class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :prepare_for_mobile

  include SessionsHelper
  
  private

	def mobile_device?
		if session[:mobile_param]
			session[:mobile_param] == "1"
		else
			request.user_agent =~ /Mobile|webOS/
		end
	end
	helper_method :mobile_device?
	
	def touch_device?
		if session[:mobile_param]
			session[:mobile_param] == "2"
		else
			request.user_agent =~ /Mobile|webOS/
		end
	end	
	helper_method :touch_device?
	
	def prepare_for_mobile
		session[:mobile_param] = params[:mobile] if params[:mobile]
		if touch_device?
			request.format = :touch
		elsif mobile_device?
			request.format = :mobile 
		end		
		#request.format = :mobile if mobile_device?
	end
end