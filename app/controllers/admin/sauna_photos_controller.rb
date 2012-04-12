class Admin::SaunaPhotosController < AdminController
	before_filter :authenticate
	before_filter :correct_sauna,  :only => [:destroy]
	before_filter :correct_user,  :except => [:destroy]
	
	def new                             
		@sauna = Sauna.find(params[:id])
		5.times { @sauna.sauna_photos.build }
	end
	
	def create
		@sauna = Sauna.find(params[:sauna][:sauna_id])		
		h = params[:sauna][:sauna_photos_attributes]	
		
		if h != nil 
			h.each do |key, value|	
				@sauna_photo = SaunaPhoto.new(:photo => h[key][:photo])
				if @sauna_photo.photo_file_size != nil
					@sauna_photo.sauna_id = @sauna.id
					@sauna_photo.description = h[key][:description]						
					@sauna_photo.save
				end
			end
		end		
				
		flash[:success] = :sauna_photo_created		 
		redirect_to '/admin/sauna/' + @sauna.id.to_s + '/sauna_photos'
	end
	
	def edit
		@sauna_photo = SaunaPhoto.find(params[:id])
	end
	
	def update
		@sauna_photo = SaunaPhoto.find(params[:id])
		if @sauna_photo.update_attributes(params[:sauna_photo])
			flash[:success] = :sauna_photo_updated		 
			redirect_to '/admin/sauna/' + @sauna_photo.sauna.id.to_s + '/sauna_photos'		
		else
			render 'edit'
		end		
	end	
	
	def destroy
		@sauna_photo = SaunaPhoto.find(params[:id])		
		@sauna = @sauna_photo.sauna
		SaunaPhoto.find(params[:id]).destroy
		flash[:success] = :sauna_photo_destroyed
		respond_to do |format|
			format.html { redirect_to edit_admin_sauna_path(@sauna) }
			format.js
		end		
	end  
	
	def index    
		@sauna = Sauna.find(params[:id])
		@sauna_photos = @sauna.sauna_photos						
	end		
	
  private
  
    def correct_sauna
		if !current_user.super_admin?
			@sauna_photo = SaunaPhoto.find(params[:id])		
			@sauna = @sauna_photo.sauna
			if !current_user?(@sauna.user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 		
			end				
		end
    end
	
	def correct_user
		if !current_user.super_admin? 
			sauna_id = params[:id] == nil ? params[:sauna][:sauna_id] : params[:id]	
			@sauna = Sauna.find(sauna_id)	
			@user = User.find(@sauna.user_id)			
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 			
			end
		end
	end		
end