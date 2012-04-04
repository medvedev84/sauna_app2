require 'digest/md5'
class Admin::BookingsController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	before_filter :correct_user
	
	def index 		
		# prepare data for dropdowns
		if current_user.owner?
			get_saunas_by_user(current_user.id)
			get_sauna_items_by_user(current_user.id)		
		else
			get_all_saunas
			get_all_sauna_items
		end
		
		# get request parameters
		h = params[:q]	
		if h == nil	
			h = {}
			
			# if this is a index page, we should show only booking for current user's saunas
			if current_user.owner?
				h["sauna_item_sauna_user_id_eq"] = current_user.id	
			end
		end
		
		# never show canceled bookings
		h["is_canceled_eq"] = false		
		h.delete_if {|key, value| key == "payment_id_present" && value == "0" } #if payments is not important, don't use that criteria	
		
		# if request from sauna page - get booking for this sauna
		if params[:id] != nil
			@sauna = Sauna.find(params[:id])			
			h["sauna_item_sauna_id_eq"] = @sauna.id				
		end	
		
		@q = Booking.search(h)									
		@current_page_number = params[:page] != nil ? params[:page] : 1
		@bookings = @q.result(:distinct => true).order("created_at DESC").page(params[:page]).per(10)
			
		respond_to do |format|
			format.html 
			format.js
		end				
	end

	def new                             
		@sauna = Sauna.find(params[:id])
		@bookings = Booking.new
	end
	
	def create
		@booking = Booking.new(params[:booking])
		prepare_payment_data(@booking)   
		
		if @booking.save			
			respond_to do |format|
				format.html { redirect_to @booking }
				format.js
			end
		else     
			render 'new'
		end		
	end	

	def show
		@booking = Booking.find(params[:id])
		respond_to do |format|
		  format.js 
		end
	end
	
	def prepare_payment_data(booking)    
		unless booking.blank? && booking.payment.blank?
		  @pay_desc = Hash.new
		  @pay_desc['mrh_url']   = Payment::MERCHANT_URL
		  @pay_desc['mrh_login'] = Payment::MERCHANT_LOGIN
		  @pay_desc['mrh_pass1'] = Payment::MERCHANT_PASS_1
		  @pay_desc['inv_id']    = 0
		  @pay_desc['inv_desc']  = booking.description
		  @pay_desc['out_summ']  = 1000
		  @pay_desc['shp_item']  = booking.id
		  @pay_desc['in_curr']   = "WMRM"
		  @pay_desc['culture']   = "ru"
		  @pay_desc['encoding']  = "utf-8"
		  @pay_desc['crc'] = Payment::get_hash(@pay_desc['mrh_login'], 
											   @pay_desc['out_summ'],
											   @pay_desc['inv_id'], 
											   @pay_desc['mrh_pass1'], 
											   "Shp_item=#{@pay_desc['shp_item']}")     
		end
	end	
	
	def correct_user
		if !current_user.super_admin? && params[:id] != nil
			@sauna = Sauna.find(params[:id])
			@user = User.find(@sauna.user_id)			
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 			
			end
		end
	end		
end