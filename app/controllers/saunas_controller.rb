class SaunasController < ApplicationController  
	include SaunasHelper
	
	def show 
		str_id = params[:id]
		
		if str_id.nonnegative_integer?
			@sauna = Sauna.find(str_id)	
		else 
			@sauna = Sauna.where("alias = ?", str_id).first		#find by alias
		end
		
		if @sauna != nil 
			@sauna_items =  @sauna.sauna_items
			@sauna_comment = SaunaComment.new
		end
	end
	
	def index
		get_all_cities
		get_all_districts	
		
		h = params[:q]
		if h != nil
			h.delete_if {|key, value| key == "sauna_items_has_kitchen_eq" && value == "0" } #if kitchen is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_restroom_eq" && value == "0" } #if restroom is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_billiards_eq" && value == "0" } #if billiards is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_audio_eq" && value == "0" } #if audio is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_video_eq" && value == "0" } #if video is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_bar_eq" && value == "0" } #if bar is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_pool_eq" && value == "0" } #if pool is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_mangal_eq" && value == "0" } #if mangal is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_veniki_eq" && value == "0" } #if veniki is not important, don't use that criteria
			
			h.delete_if {|key, value| key == "sauna_items_sauna_type_id_eq" && value == "6" } #if sauna type is not important, don't use that criteria
			
			#if district is not important, don't use that criteria	
			if h.has_key?("address_district_id_eq")
				@district =  District.find(h["address_district_id_eq"]) 									
				if @district.is_all?
					h.delete_if {|key, value| key == "address_district_id_eq" } 
				end						
			end
						
			@q = Sauna.search(h)					
			@saunas = @q.result(:distinct => true)				
		else		
			@q = Sauna.search(h)								
			@saunas = Array.new # return empty array if visit index page at the first time
		end
		
		if (mobile_device? || touch_device? ) && h != nil 
			render 'search'
		else	
			respond_to do |format|
				format.html { render 'index' }
				format.js
			end		
		end			
	end
end
