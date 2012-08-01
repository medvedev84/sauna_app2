class Admin::CouponDealsController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	
	def index 	
		# prepare data for dropdowns	
		get_all_coupon_urls
				
		# get request parameters
		h = params[:q]	
		if h == nil	
			h = {}
		end	
		
		@q = CouponDeal.search(h)											
		@coupon_deals = @q.result(:distinct => true)
			
		respond_to do |format|
			format.html 
			format.js
		end				
	end

	def new     
		# prepare data for dropdowns	
		get_all_coupon_urls
		@coupon_deal = CouponDeal.new
	end
	
	def create
		@coupon_deal = CouponDeal.new(params[:coupon_deal])				
		if @coupon_deal.save			
			flash[:success] = :coupon_deal_created
			redirect_to admin_coupon_deals_path
		else     
			render 'new'
		end		
	end	

	def show
		@coupon_deal = CouponDeal.find(params[:id])
		respond_to do |format|
		  format.js 
		end
	end
	
	def edit
		# prepare data for dropdowns
		get_all_coupon_urls
		@coupon_deal = CouponDeal.find(params[:id])
	end

	def update
		@coupon_deal = CouponDeal.find(params[:id])				
		if @coupon_deal.update_attributes(params[:coupon_deal])				
			flash[:success] = :coupon_deal_updated 
			redirect_to admin_coupon_deals_path			
		else
			render 'edit'
		end				
	end

	def destroy
		CouponDeal.find(params[:id]).destroy
		flash[:success] = :coupon_deal_destroyed
		redirect_to admin_coupon_deals_path
	end	
	
end