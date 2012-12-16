class PagesController < ApplicationController
	include SaunasHelper

	def index
		get_all_cities
		
		if params[:q] != nil	
			save_search_params(params[:q])			
		end
		
		h = get_search_params					
		@q = Sauna.search(get_search_params)
		
		if (mobile_device? || touch_device? ) && params[:q]  != nil 
			@saunas = @q.result(:distinct => true)
			render 'search'
		end
			
	end
end
