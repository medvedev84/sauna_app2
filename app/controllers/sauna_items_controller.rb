class SaunaItemsController < ApplicationController

	def show
		@sauna_item = SaunaItem.find(params[:id])  
		@sauna = @sauna_item.sauna
		@sauna_comment = SaunaComment.new
		@title = @sauna_item.name 
	end
end