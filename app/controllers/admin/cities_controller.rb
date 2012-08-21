class Admin::CitiesController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	
	def index 	
		# get request parameters
		h = params[:q]	
		if h == nil	
			h = {}
		end	
		
		@q = City.search(h)											
		@cities = @q.result(:distinct => true)
			
		respond_to do |format|
			format.html 
			format.js
		end		
	end

	def new     
		@city = City.new
	end
	
	def create
		@city = City.new(params[:city])				
		if @city.save			
			flash[:success] = :city_created
			redirect_to admin_cities_path
		else     
			render 'new'
		end		
	end	

	def show
		@city = City.find(params[:id])
	end
	
	def edit
		@city = City.find(params[:id])
	end

	def update
		@city = City.find(params[:id])				
		if @city.update_attributes(params[:city])				
			flash[:success] = :city_updated 
			redirect_to admin_cities_path			
		else
			render 'edit'
		end				
	end	
end