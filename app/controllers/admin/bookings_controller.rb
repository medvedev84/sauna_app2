require 'digest/md5'
class Admin::BookingsController < ApplicationController

	def index 	
		@saunas = current_user.saunas
		
		h = params[:q]
		if h != nil
						
			h.delete_if {|key, value| key == "sauna_items_sauna_type_id_eq" && value == "6" } #if sauna type is not important, don't use that criteria
									
			@q = Booking.search(h)					
			@bookings = @q.result(:distinct => true)							
		else	
			
			if params[:id] != nil
				@sauna = Sauna.find(params[:id])
				h = {}
				h["sauna_id_eq"] = @sauna.id
				
				@q = Booking.search(h)								
				@bookings = Array.new # return empty array if visit index page at the first time				
			else
				@q = Booking.search(h)								
				@bookings = Array.new # return empty array if visit index page at the first time
			end		
			

			
			#@q = Booking.search(h)								
			#@bookings = Array.new # return empty array if visit index page at the first time
		end
		
		respond_to do |format|
			format.html { render 'index' }
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
end