class Admin::UsersController < ApplicationController
	before_filter :authenticate, :only => [:index, :show, :edit, :update, :destroy]
	before_filter :correct_user, :only => [:index, :show, :edit, :update]

	def show
		@user = User.find(params[:id])
		@saunas = @user.saunas.paginate(:page => params[:page], :per_page => 10)
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
		if h != nil			
			@users = @q.result(:distinct => true)
		else
			@users = User.all
		end	
		
		respond_to do |format|
			format.html { render 'index' }
			format.js
		end			
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			Notifier.update_user_email(@user).deliver		
			flash[:success] = :profile_updated 
			redirect_to admin_users_path
		else
			render 'edit'
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
			flash[:error] = :access_denied
			redirect_to('/incorrect') 			
		end
	end
end