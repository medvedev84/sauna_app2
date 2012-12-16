class CitiesController < ApplicationController 
	include SaunasHelper
	
	respond_to :html, :js, :mobile, :touch
	
	def index
		if (params["json"] == "true") 
			@cities = City.all
			render :json => @cities.as_json(:only => [:id, :name])
		else
			redirect_to(root_path)	
		end
	end	
	
	def izhevsk
		h = params[:q]
		prepareForSearch(h, 1)		
	end  
	
	def votkinsk
		h = params[:q]
		prepareForSearch(h, 2)
	end  

	def glazov
		h = params[:q]
		prepareForSearch(h, 3)
	end  	
	
	def sarapul
		h = params[:q]		
		prepareForSearch(h, 4)
	end  

	def mozhga
		h = params[:q]		
		prepareForSearch(h, 5)
	end  
	
	def kirov
		h = params[:q]		
		prepareForSearch(h, 6)
	end  

	def kazan
		h = params[:q]		
		prepareForSearch(h, 7)
	end  

	def chelni
		h = params[:q]		
		prepareForSearch(h, 8)
	end  

	def nizhnekamsk
		h = params[:q]		
		prepareForSearch(h, 9)
	end  

	def neftekamsk
		h = params[:q]		
		prepareForSearch(h, 10)
	end  	
	
	def perm
		h = params[:q]		
		prepareForSearch(h, 11)
	end 

	def ufa
		h = params[:q]		
		prepareForSearch(h, 12)
	end 

	def sterlitamak
		h = params[:q]		
		prepareForSearch(h, 13)
	end 

	def yola
		h = params[:q]		
		prepareForSearch(h, 14)
	end 
	
	def ekaterinburg
		h = params[:q]		
		prepareForSearch(h, 15)
	end 

	def cheboksari
		h = params[:q]		
		prepareForSearch(h, 16)
	end 

	def ulyanovsk
		h = params[:q]		
		prepareForSearch(h, 17)
	end 

	def chelyabinsk
		h = params[:q]		
		prepareForSearch(h, 18)
	end 	
	
	def magnitogorsk
		h = params[:q]		
		prepareForSearch(h, 19)
	end

	def samara
		h = params[:q]		
		prepareForSearch(h, 20)
	end 

	def togliatti
		h = params[:q]		
		prepareForSearch(h, 21)
	end 

	def syzran
		h = params[:q]		
		prepareForSearch(h, 22)
	end 

	def penza
		h = params[:q]		
		prepareForSearch(h, 23)
	end 

	def saransk
		h = params[:q]		
		prepareForSearch(h, 24)
	end 

	def saratov
		h = params[:q]		
		prepareForSearch(h, 25)
	end 

	def engels
		h = params[:q]		
		prepareForSearch(h, 26)
	end 

	def tambov
		h = params[:q]		
		prepareForSearch(h, 27)
	end 	
	
	def lipetsk
		h = params[:q]		
		prepareForSearch(h, 28)
	end 

	def voronezh
		h = params[:q]		
		prepareForSearch(h, 29)
	end 	
	
	def search
		@city = City.find(1)
		
		if params[:q] != nil	
			save_search_params(params[:q])			
		end
		h = get_search_params		

		performSearch(h)					
	end 	
	
	private 

		def prepareForSearch(h, city_id)	
			@city = City.find(city_id)
			if h == nil
				h = Hash.new
			end		
			h["address_city_id_eq"] = city_id.to_s					
			performSearch(h)				
		end		
		
		def performSearch(h)
		
			if h != nil
				h.delete_if {|key, value| key == "sauna_items_has_billiards_eq" && value == "0" } #if billiards is not important, don't use that criteria
				h.delete_if {|key, value| key == "sauna_items_has_bar_eq" && value == "0" } #if bar is not important, don't use that criteria
				h.delete_if {|key, value| key == "sauna_items_has_pool_eq" && value == "0" } #if pool is not important, don't use that criteria
				h.delete_if {|key, value| key == "sauna_items_has_mangal_eq" && value == "0" } #if mangal is not important, don't use that criteria			
				h.delete_if {|key, value| key == "sauna_items_sauna_type_id_eq" && value == "6" } #if sauna type is not important, don't use that criteria						
			end
		
			@q = Sauna.search(h)	
			if (mobile_device? || touch_device? ) 
				respond_with(@saunas = @q.result(:distinct => true)) do |format|
					format.mobile { render "city" }	
					format.touch { render "city" } 				
				end				
			else	
				@current_page_number = params[:page] != nil ? params[:page] : 1		
				respond_with(@saunas = @q.result(:distinct => true).page(params[:page]).per(10)	) do |format|
					format.html { render "city" }	
					format.js { render "city" }					
				end
			end					
		end		
end