class SaunaItemsController < ApplicationController

	def show
		@sauna_item = SaunaItem.find(params[:id])  
		@title = @sauna_item.name 
	end
end