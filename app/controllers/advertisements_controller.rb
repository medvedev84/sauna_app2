class AdvertisementsController < ApplicationController

	def index				
		if (params["json"] == "true") 
			#str_id = params[:id]			
			#@advertisements = Advertisement.where("city_id = ?", str_id)		
			@advertisements = Advertisement.all
			render :json => @advertisements.as_json(:only => [:city_id, :company_name, :description, :phone_number])
		else
			redirect_to(root_path)	
		end
	end	
end