class Admin::SaunaPhotosController < ApplicationController

	def new                             
		@sauna = Sauna.find(params[:id])
		5.times { @sauna.sauna_photos.build }
	end
	
	def create
		@sauna = Sauna.find(params[:sauna_photos_attributes][:sauna_id])		
		h = params[:sauna_photos_attributes]	
		
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
				
		flash[:success] = :sauna_item_created		 
		redirect_to '/admin/sauna/' + @sauna.id.to_s + '/sauna_photos'
	end
	
	def update
		@sauna = Sauna.find(params[:sauna_photos_attributes][:sauna_id])		
		h = params[:sauna_photos_attributes]	
		
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
				
		flash[:success] = :sauna_item_created		 
		redirect_to '/admin/sauna/' + @sauna.id.to_s + '/sauna_photos'
	end	
	
	def destroy
		@sauna_photo = SaunaPhoto.find(params[:id])		
		@sauna = @sauna_photo.sauna
		SaunaPhoto.find(params[:id]).destroy
		flash[:success] = "Sauna photo destroyed."
		respond_to do |format|
			format.html { redirect_to edit_admin_sauna_path(@sauna) }
			format.js
		end		
	end  
	
	def index    
		@sauna = Sauna.find(params[:id])
		@sauna_photos = @sauna.sauna_photos						
	end		
end