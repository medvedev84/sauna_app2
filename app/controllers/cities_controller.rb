class CitiesController < ApplicationController 
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
	
	def kirov
		h = params[:q]		
		search(h, 6)
	end  

	def kazan
		h = params[:q]		
		search(h, 7)
	end  

	def chelni
		h = params[:q]		
		search(h, 8)
	end  

	def nizhnekamsk
		h = params[:q]		
		search(h, 9)
	end  

	def neftekamsk
		h = params[:q]		
		search(h, 10)
	end  	
	
	def perm
		h = params[:q]		
		search(h, 11)
	end 

	def ufa
		h = params[:q]		
		search(h, 12)
	end 

	def sterlitamak
		h = params[:q]		
		search(h, 13)
	end 

	def yola
		h = params[:q]		
		search(h, 14)
	end 
	
	def ekaterinburg
		h = params[:q]		
		search(h, 15)
	end 

	def cheboksari
		h = params[:q]		
		search(h, 16)
	end 

	def ulyanovsk
		h = params[:q]		
		search(h, 17)
	end 

	def chelyabinsk
		h = params[:q]		
		search(h, 18)
	end 	
	
	def magnitogorsk
		h = params[:q]		
		search(h, 19)
	end

	def samara
		h = params[:q]		
		search(h, 20)
	end 

	def togliatti
		h = params[:q]		
		search(h, 21)
	end 

	def syzran
		h = params[:q]		
		search(h, 22)
	end 

	def penza
		h = params[:q]		
		search(h, 23)
	end 

	def saransk
		h = params[:q]		
		search(h, 24)
	end 

	def saratov
		h = params[:q]		
		search(h, 25)
	end 

	def engels
		h = params[:q]		
		search(h, 26)
	end 

	def tambov
		h = params[:q]		
		search(h, 27)
	end 	
	
	def lipetsk
		h = params[:q]		
		search(h, 28)
	end 

	def voronezh
		h = params[:q]		
		search(h, 29)
	end 	
	
	private 

		def search(h, city_id)	
			@city = City.find(city_id)
			if h == nil
				h = Hash.new
			end		
			h["address_city_id_eq"] = city_id.to_s		
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