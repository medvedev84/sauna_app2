require 'digest/md5'

class BookingsController < ApplicationController

	def index   
		@bookings = Booking.scoped  
		@bookings = @bookings.after(params['start']) if (params['start'])
		@bookings = @bookings.before(params['end']) if (params['end'])

		@bookings = @bookings.where("sauna_item_id = ?", params[:sauna_item_id])
		
		respond_to do |format|
		  format.html 
		  format.xml  { render :xml => @bookings }
		  format.js  { render :json => @bookings }		  
		end
	end

	# TODO
	def show
		@booking = Booking.find(params[:id])

		respond_to do |format|
		  format.html # show.html.erb
		  format.xml  { render :xml => @booking }
		  format.js { render :json => @booking.to_json }
		end
	end
	
	def create
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		@booking = Booking.new(params[:booking])
		if email_regex =~ @booking.email 
			if @booking.save				
				prepare_payment_data(@booking, params[:provider_type])  								
				Notifier.booking_created_email_to_owner(@booking).deliver
				Notifier.booking_created_email_to_customer(@booking).deliver
				sms_notification(@booking)							
				respond_to do |format|
					format.html { redirect_to @booking }
					format.js
				end
			else    
				@booking.errors
				render 'new'
			end			
		else
			@booking.errors["email"] = t (:email_format)
			render 'new'		
		end
	end	
	
	def sms_notification(booking)
		booking_details_text = t(:sauna) + ": " + booking.sauna_item.sauna.name + " (" + booking.sauna_item.name + "). " + t(:date) + ": " + booking.starts_at.strftime("%d.%m.%Y") + ". " + t(:time) + ": " + booking.starts_at.strftime("%H:%M") + "-" + booking.ends_at.strftime("%H:%M")
		# send sms to admin
		message_text = t(:booking_created_to_admin) + " " + booking_details_text
		admin_number = SiteSetting.get_phone_number
		send_sms(booking.id, message_text, admin_number)			
		
		# send sms to customer
		message_text =  t(:booking_created_to_client) + " " + booking_details_text
		send_sms(booking.id, message_text, booking.phone_number)
		
		# send sms to owner
		message_text = t(:booking_created_to_owner) + " " + booking_details_text
		#send_sms(booking.id, message_text, booking.sauna_item.sauna.phone_number1)
		send_sms(booking.id, message_text, admin_number)
	end
	
	def send_sms(booking_id, message_text, phone_number)		
		sms_text = message_text.tr(" ", "+")
		code, sms_id = SmsSender.send_simple(phone_number, sms_text)				
		sms_message = SmsMessage.new(:booking_id => booking_id, :sms_number => sms_id, :status => code, :message_text => message_text, :phone_number => phone_number)
		sms_message.save	
	end
  
  def prepare_payment_data(booking, provider_type)    
    unless booking.blank? && booking.payment.blank?
      @pay_desc = Hash.new
	  @pay_desc['provider_type']   = provider_type
      @pay_desc['mrh_url']   = Payment::MERCHANT_URL
      @pay_desc['mrh_login'] = Payment::MERCHANT_LOGIN
      @pay_desc['mrh_pass1'] = Payment::MERCHANT_PASS_1
      @pay_desc['inv_id']    = 0
      @pay_desc['inv_desc']  = booking.description
      @pay_desc['out_summ']  = SiteSetting.get_booking_fee
      @pay_desc['shp_item']  = booking.id
      @pay_desc['in_curr']   = "WMRM"
      @pay_desc['culture']   = "ru"
      @pay_desc['encoding']  = "utf-8"
      @pay_desc['crc'] = Payment::get_rk_hash(@pay_desc['mrh_login'], 
                                           @pay_desc['out_summ'],
                                           @pay_desc['inv_id'], 
                                           @pay_desc['mrh_pass1'], 
                                           "Shp_item=#{@pay_desc['shp_item']}")     
    end
  end	
end