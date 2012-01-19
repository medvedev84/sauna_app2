class SaunasController < ApplicationController
  
	def show
		# ugly hack for back url
		if /address_district_id_eq/ =~ request.env['HTTP_REFERER']
			@back_url = request.env['HTTP_REFERER']
		end    
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
		end
		@q = Sauna.search(h)	
		if mobile_device? 
			@saunas = @q.result(:distinct => true)
			if h != nil 			
				render 'search'
			else
				render 'index'
			end		
		else
			#@saunas = @q.result(:distinct => true).paginate(:page => params[:page], :per_page => 10)	
			@saunas = @q.result(:distinct => true)	
		end	
	end
end
