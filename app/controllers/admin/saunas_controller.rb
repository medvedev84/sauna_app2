class Admin::SaunasController < ApplicationController
  before_filter :authenticate, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user, :only => :new

  def new                             
    @user = User.find(params[:user_id])
    @address = Address.new
    @sauna = Sauna.new
	5.times { @sauna.sauna_photos.build }
  end

	def create
		@user = User.find(params[:sauna][:user_id])
		@sauna = @user.saunas.build(params[:sauna])
		@address = Address.new(params[:sauna][:address])
		
		if @address.save 
			if @sauna.save 
				@address.sauna_id = @sauna.id
				@address.save
							   
				h = params[:sauna][:sauna_photos_attributes]
				#if h != nil
					h.each do |key, value|
						@sauna_photo = SaunaPhoto.new(value)
						@sauna_photo.sauna_id = @sauna.id
						@sauna_photo.save
					end
				#end

				flash[:success] = :sauna_created
				redirect_to admin_users_path
			else     
				render 'new'
			end	
		else
			render 'new'
		end
	end                   

	def edit
		@sauna = Sauna.find(params[:id])
		@address = @sauna.address
		5.times { @sauna.sauna_photos.build }
	end
  
	def show
		@sauna = Sauna.find(params[:id])
		@address = @sauna.address		
	end  

	def update
		@sauna = Sauna.find(params[:id])
		@address = @sauna.address

		if @address.update_attributes(params[:sauna][:address])
			if @sauna.update_attributes(params[:sauna])	

				h = params[:sauna][:sauna_photos_attributes]
				if h != nil 
					h.each do |key, value|	
						@sauna_photo = SaunaPhoto.new(value)
						if @sauna_photo.photo_file_size != nil
							@sauna_photo.sauna_id = @sauna.id
							@sauna_photo.save						
						end
					end
				end
				flash[:success] = :sauna_updated
				redirect_to admin_user_path(@sauna.user)
			else
				render 'edit'
			end 
		else
			render 'edit'
		end
	end
          
  def index
	redirect_to admin_user_path(current_user)   
  end

  def destroy
  	@sauna = Sauna.find(params[:id])
	@user = @sauna.user
    Sauna.find(params[:id]).destroy
    flash[:success] = "Sauna destroyed."
	redirect_to admin_user_path(@user)
  end

	private

		def correct_user
		  @sauna = Sauna.find(params[:id])
		  @user = User.find(@sauna.user_id)
		  redirect_to(root_path) unless current_user?(@user)
		end	

end
