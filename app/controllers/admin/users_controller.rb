class Admin::UsersController < AdminController
	before_filter :authenticate, :only => [:index, :show, :edit, :update, :destroy]
	before_filter :correct_user, :only => [:index, :show, :edit, :update]
	before_filter :super_admin_user, :only => [:new, :destroy]

	def show
		@user = User.find(params[:id])		
		@current_page_number = params[:page] 
		@saunas = @user.saunas.page(params[:page]).per(10)	
		@booking = Booking.new			
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			# Deliver the signup_email
			Notifier.welcome_email(@user).deliver
			
			# Show success message
			flash[:success] = :user_created
			
			# redirect to list of user
			redirect_to admin_users_path
		else
			render 'new'
		end			
	end

	def index 
		h = params[:q]
		@q = User.search(h)			
		@users = @q.result(:distinct => true).page(params[:page]).per(10)									
		@current_page_number = params[:page] 				
		respond_to do |format|
			format.html 
			format.js
		end			
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		
		# if somebody tries to send incorrect parameters
		if params[:user].has_key?("user_type") && !current_user.super_admin?			
			# somebody who is not administrator - kick him!
			@user.errors["user_type"] = t (:access_denied)
			render 'edit'
		else
			# administrator is able to modify user type - continue
			if @user.update_attributes(params[:user])
				Notifier.update_user_email(@user).deliver		
				flash[:success] = :profile_updated 
				
				if current_user.owner?
					render 'edit'
				else
					redirect_to admin_users_path
				end				
			else
				render 'edit'
			end				
		end				
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = :user_destroyed
		redirect_to admin_users_path
	end

	private

	def correct_user     
		if !current_user.super_admin?  
			@user = User.find(params[:id])			
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 				
			end		
		end
	end
end