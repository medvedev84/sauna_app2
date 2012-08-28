class Admin::DistrictsController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	
	def index 	
		# get request parameters
		h = params[:q]	
		if h == nil	
			h = {}
		end	
		
		@q = District.search(h)											
		@districts = @q.result(:distinct => true)
			
		respond_to do |format|
			format.html 
			format.js
		end		
	end

	def new   
		@city = City.find(params[:city_id])	
		@district = District.new
	end
	
	def create	
		@city = City.find(params[:district][:city_id])
		@district = @city.districts.build(params[:district])
		
		if @district.save			
			flash[:success] = :district_created
			redirect_to admin_city_path(@district.city)
			#redirect_to admin_cities_path
		else     
			render 'new'
		end		
	end	

	def show
		@district = District.find(params[:id])
	end
	
	def edit		
		@district = District.find(params[:id])
		@city = @district.city
	end

	def update
		@district = District.find(params[:id])				
		if @district.update_attributes(params[:district])				
			flash[:success] = :district_updated 			
			redirect_to admin_city_path(@district.city)			
		else
			render 'edit'
		end				
	end	
	
	def destroy
		city_id = District.find(params[:id]).city_id
		District.find(params[:id]).destroy
		flash[:success] = :district_deleted		
		redirect_to admin_city_path(city_id)
	end		
end