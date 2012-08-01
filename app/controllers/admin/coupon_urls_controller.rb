class Admin::CouponUrlsController < AdminController
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
		
		@q = CouponUrl.search(h)											
		@coupon_urls = @q.result(:distinct => true)
			
		respond_to do |format|
			format.html 
			format.js
		end				
	end

	def new     
		# prepare data for dropdowns
		get_all_cities	
		@coupon_url = CouponUrl.new
	end
	
	def create
		@coupon_url = CouponUrl.new(params[:coupon_url])				
		if @coupon_url.save			
			flash[:success] = :coupon_url_created
			redirect_to admin_coupon_urls_path
		else     
			render 'new'
		end		
	end	

	def show
		@coupon_url = CouponUrl.find(params[:id])
		respond_to do |format|
		  format.js 
		end
	end
	
	def edit
		get_all_cities	
		@coupon_url = CouponUrl.find(params[:id])
	end

	def update
		@coupon_url = CouponUrl.find(params[:id])				
		if @coupon_url.update_attributes(params[:coupon_url])				
			flash[:success] = :coupon_url_updated 
			redirect_to admin_coupon_urls_path			
		else
			render 'edit'
		end				
	end

	def destroy
		CouponUrl.find(params[:id]).destroy
		flash[:success] = :coupon_url_destroyed
		redirect_to admin_coupon_urls_path
	end	
	
end