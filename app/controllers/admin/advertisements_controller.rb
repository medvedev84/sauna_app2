class Admin::AdvertisementsController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	
	def index 	
		# prepare data for dropdowns
		get_all_cities	
				
		# get request parameters
		h = params[:q]	
		if h == nil	
			h = {}
		end	
		
		@q = Advertisement.search(h)											
		@advertisements = @q.result(:distinct => true)
			
		respond_to do |format|
			format.html 
			format.js
		end				
	end

	def new     
		# prepare data for dropdowns
		get_all_cities	
		@advertisement = Advertisement.new
	end
	
	def create
		@advertisement = Advertisement.new(params[:advertisement])				
		if @advertisement.save			
			# Show success message
			flash[:success] = :advertisement_created
			
			# redirect to list of user
			redirect_to admin_advertisements_path
		else     
			render 'new'
		end		
	end	

	def show
		@advertisement = Advertisement.find(params[:id])
		respond_to do |format|
		  format.js 
		end
	end
	
	

	def edit
		get_all_cities	
		@advertisement = Advertisement.find(params[:id])
	end

	def update
		@advertisement = Advertisement.find(params[:id])				
		if @advertisement.update_attributes(params[:advertisement])				
			flash[:success] = :advertisement_updated 
			redirect_to admin_advertisements_path			
		else
			render 'edit'
		end				
	end

	def destroy
		Advertisement.find(params[:id]).destroy
		flash[:success] = :advertisement_destroyed
		redirect_to admin_advertisements_path
	end	
	
end