class SaunaItemsController < ApplicationController
	def show
		@sauna_item = SaunaItem.find(params[:id])  
		@sauna = @sauna_item.sauna
		@sauna_comment = SaunaComment.new
		@title = @sauna_item.name 
		
		if (params["json"] == "true") 			
			render :json => @sauna_item
		end			
	end
end