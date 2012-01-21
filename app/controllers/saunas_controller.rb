class SaunasController < ApplicationController  
	def show 
		@sauna = Sauna.find(params[:id])
		@sauna_items =  @sauna.sauna_items
		@sauna_comment = SaunaComment.new
	end
          
	def index
		h = params[:q]
		if h != nil
			h.delete_if {|key, value| key == "sauna_items_has_kitchen_eq" && value == "0" } #if kitchen is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_restroom_eq" && value == "0" } #if restroom is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_billiards_eq" && value == "0" } #if billiards is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_audio_eq" && value == "0" } #if audio is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_video_eq" && value == "0" } #if video is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_has_bar_eq" && value == "0" } #if bar is not important, don't use that criteria
			h.delete_if {|key, value| key == "sauna_items_sauna_type_id_eq" && value == "" } #if sauna type is not important, don't use that criteria
			h.delete_if {|key, value| key == "address_district_id_eq" && value == "" } #if address is not important, don't use that criteria
		end
		@q = Sauna.search(h)	
		
		@saunas = @q.result(:distinct => true)	
		if (mobile_device? || touch_device? ) && h != nil 	
			render 'search'
		else	
			render 'index'		
		end	
	end
end
