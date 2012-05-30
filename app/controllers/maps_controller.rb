class MapsController < ApplicationController
	include SaunasHelper
	layout "map"
	
	def index
		get_all_cities
		h = params[:q]		
		search(h)
	end  	
	
	private 

		def search(h)
			if h == nil
				h = Hash.new
				h["address_city_id_eq"] = "1"
			end		
			city_id = h["address_city_id_eq"].to_i
			@city = City.find(city_id)
			@q = Sauna.search(h)	
			@saunas = @q.result(:distinct => true)		
			respond_to do |format|
				format.html 
				format.js
			end						
		end	
end