class CitiesController < ApplicationController 
  
	def izhevsk
		h = params[:q]
		search(h, 1)
	end  
	
	def votkinsk
		h = params[:q]
		search(h, 2)
	end  

	def glazov
		h = params[:q]
		search(h, 3)
	end  	
	
	def sarapul
		h = params[:q]		
		search(h, 4)
	end  

	def mozhga
		h = params[:q]		
		search(h, 5)
	end  
	
	private 

		def search(h, city_id)
			if h == nil
				h = Hash.new
			end		
			h["address_city_id_eq"] = city_id.to_s		
			@q = Sauna.search(h)	
			if (mobile_device? || touch_device? ) 
				@saunas = @q.result(:distinct => true)		
			else	
				@current_page_number = params[:page] != nil ? params[:page] : 1		
				@saunas = @q.result(:distinct => true).page(params[:page]).per(10)	
				respond_to do |format|
					format.html 
					format.js
				end		
			end					
		end
end
