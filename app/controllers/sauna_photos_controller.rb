class SaunaPhotosController < ApplicationController  
	
	def show 
		str_id = params[:id]
		@sauna = Sauna.find(str_id)			
		if (params["json"] == "true") 										
			@sauna.sauna_photos.each do |item| 
				item.size = params["photo_type"] 
			end		
			render :json => @sauna.as_json(:only => [:id],
				:include => {			
				  :sauna_photos => {:only => [:id], :methods => :photo_url_thumb}
				}					
			)		
		end			
	end
	
end
