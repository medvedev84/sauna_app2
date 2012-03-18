module SaunasHelper
 
	def save_search_params(search_params)
		session[:search_params] = search_params
	end
  
    def get_search_params
		session[:search_params]
    end
  
	def get_all_cities
		@cities = City.all		
		@cities_for_dropdown = []
		@cities.each do |city|
			@cities_for_dropdown = @cities_for_dropdown << [city.name, city.id]
		end
	end
	
	def get_all_districts
		@districts = District.order("city_id ASC, id DESC")
		@districts_for_dropdown = []
		@districts.each do |district|
			@districts_for_dropdown = @districts_for_dropdown << [district.name, district.id, {:class => district.city.id}]
		end	
	end
	
	def get_districts_for_edit_form
		@districts = District.all
		@districts_for_dropdown = []
		@districts.each do |district|
			if !district.is_all? 
				@districts_for_dropdown = @districts_for_dropdown << [district.name, district.id, {:class => district.city.id}]
			end
		end	
	end	
	
end
