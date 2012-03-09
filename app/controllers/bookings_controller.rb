require 'digest/md5'

class BookingsController < ApplicationController

	def index   
		@bookings = Booking.scoped  
		@bookings = @bookings.after(params['start']) if (params['start'])
		@bookings = @bookings.before(params['end']) if (params['end'])

		@bookings = @bookings.where("sauna_id = ?", params[:sauna_id])
		
		respond_to do |format|
		  format.html 
		  format.xml  { render :xml => @bookings }
		  format.js  { render :json => @bookings }		  
		end
	end

	# TODO
	def show
		@event = Booking.find(params[:id])

		respond_to do |format|
		  format.html # show.html.erb
		  format.xml  { render :xml => @event }
		  format.js { render :json => @event.to_json }
		end
	end
	
	def create
		@booking = Booking.new(params[:booking])
		prepare_payment_data(@booking)   
		
		if @booking.save	
			# Deliver the email to owner and customer
			#Notifier.booking_created_email_to_owner(@booking).deliver
			#Notifier.booking_created_email_to_customer(@booking).deliver
			
			# send sms to owner and customer
			send_sms(@booking)			
			
			respond_to do |format|
				format.html { redirect_to @booking }
				format.js
			end
		else    
			@booking.errors
			render 'new'
		end		
	end	

	def send_sms(booking)
		# send sms to admin
		message_text = "New+booking+was+maden"
		admin_number = "79043102536"
		code, sms_id = SmsSender.send_simple(admin_number, message_text)
		sms_message = SmsMessage.new(:booking_id => booking.id, :sms_number => sms_id, :status => code, :message_text => message_text, :phone_number => admin_number)
		sms_message.save
		
		# send sms to customer
		message_text = "You+made+booking+for+sauna"
		code, sms_id = SmsSender.send_simple(booking.phone_number, message_text)
		sms_message = SmsMessage.new(:booking_id => booking.id, :sms_number => sms_id, :status => code, :message_text => message_text, :phone_number => booking.phone_number)
		sms_message.save
		
		# send sms to owner
		message_text = "Your+sauna+has+been+booked"
		code, sms_id = SmsSender.send_simple(booking.sauna.phone_number1, message_text)				
		sms_message = SmsMessage.new(:booking_id => booking.id, :sms_number => sms_id, :status => code, :message_text => message_text, :phone_number => booking.sauna.phone_number1)
		sms_message.save		
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