class Admin::SessionsController < AdminController
  def new
  end     

  def create    
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
		sign_in user
		#@sms_id = Sms.send("79043102536","hello")
		if user.super_admin? 
			redirect_to admin_users_path  
		elsif user.tester?     
			redirect_to root_path
		else   
			redirect_to admin_saunas_path			
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