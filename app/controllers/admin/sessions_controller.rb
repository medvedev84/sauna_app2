class Admin::SessionsController < ApplicationController
  def new
  end     

  def create    
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if user.admin? 
        redirect_to admin_users_path  
      else 
        #redirect_back_or user    
		redirect_to admin_user_path(user) 
      end
    else
      flash.now.alert = :invalid_email_or_password
      render "new"	  
    end
  end	     

  def destroy
    sign_out
    redirect_to root_path
  end
end
        