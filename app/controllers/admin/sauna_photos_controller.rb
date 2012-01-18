class Admin::SaunaPhotosController < ApplicationController

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
end