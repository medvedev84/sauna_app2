class MapsController < ApplicationController
	layout "map"
	
	def index
		h = params[:q]		
		search(h, 1)
	end  	
	
	private 

		def search(h, city_id)
			if h == nil
				h = Hash.new
			end		
			h["address_city_id_eq"] = city_id.to_s		
			@q = Sauna.search(h)	
			@saunas = @q.result(:distinct => true)		
			respond_to do |format|
				format.html 
				format.js
			end						
		end	
end