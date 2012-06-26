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
		search(h, 1, '/izhevsk')		
	end  
	
	def votkinsk
		h = params[:q]
		search(h, 2, '/votkinsk')
	end  

	def glazov
		h = params[:q]
		search(h, 3, '/glazov')
	end  	
	
	def sarapul
		h = params[:q]		
		search(h, 4, '/sarapul')
	end  

	def mozhga
		h = params[:q]		
		search(h, 5, '/mozhga')
	end  
	
	def kirov
		h = params[:q]		
		search(h, 6, '/kirov')
	end  

	def kazan
		h = params[:q]		
		search(h, 7, '/kazan')
	end  

	def chelni
		h = params[:q]		
		search(h, 8, '/chelni')
	end  

	def nizhnekamsk
		h = params[:q]		
		search(h, 9, '/nizhnekamsk')
	end  

	def neftekamsk
		h = params[:q]		
		search(h, 10, '/neftekamsk')
	end  	
	
	def perm
		h = params[:q]		
		search(h, 11, '/perm')
	end 

	def ufa
		h = params[:q]		
		search(h, 12, '/ufa')
	end 

	def sterlitamak
		h = params[:q]		
		search(h, 13, '/sterlitamak')
	end 

	def yola
		h = params[:q]		
		search(h, 14, '/yola')
	end 
	
	private 

		def search(h, city_id, city_path)
			get_city_name(city_path)
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
				@city_path = city_path
				respond_with(@saunas = @q.result(:distinct => true).page(params[:page]).per(10)	) do |format|
					format.html { render "city" }	
					format.js { render "city" }					
				end
			end					
		end
		
		def get_city_name(city_path)
			city = t(:izhevsk)			
			if city_path.include?("izhevsk")
				city = t(:izhevska)
			elsif city_path.include?("sarapul")
				city = t(:sarapula)		
			elsif city_path.include?("votkinsk")
				city = t(:votkinska)
			elsif city_path.include? "mozhga"  	
				city = t(:mozhgi) 	
			elsif city_path.include? "glazov"  		
				city = t(:glazova)	
			elsif city_path.include? "kirov"  		
				city = t(:kirova) 		
			elsif city_path.include? "kazan"  		
				city = t(:kazani)	
			elsif city_path.include? "chelni"  		
				city = t(:chelnov) 					
			elsif city_path.include? "nizhnekamsk"  	
				city = t(:nizhnekamska) 				
			elsif city_path.include? "neftekamsk"  	
				city = t(:neftekamska) 		
			elsif city_path.include? "sterlitamak"  	
				city = t(:sterlitamaka) 	
			elsif city_path.include? "perm"  	
				city = t(:permi) 	
			elsif city_path.include? "yola"  	
				city = t(:yoli) 	
			elsif city_path.include? "ufa"  	
				city = t(:ufi) 					
			else 
				city = t(:izhevska) 
			end 
			@city_name = city
		end
end