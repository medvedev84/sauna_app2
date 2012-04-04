require 'digest/md5'

class PaymentsController < ApplicationController

  def result
    crc = Payment.get_hash(params['OutSum'], 
                            params['InvId'], 
                            Payment::MERCHANT_PASS_2,
                            "Shp_item=#{params['Shp_item']}")  
    @result = "FAIL"
    1.times do |x|      
		break if params['SignatureValue'].blank? || crc.casecmp(params['SignatureValue']) != 0
		@booking = Booking.where(:id => params['Shp_item']).first
		break if @booking.blank? || params['OutSum'].to_f != SiteSetting.get_booking_fee

		ActiveRecord::Base.transaction do 
			#create payment
			@payment = Payment.new
			@payment.amount = params['OutSum'].to_f 
			@payment.booking_id = @booking.id	
			@payment.description = t(:payment_created) + params['InvId'] + ". " + t(:sauna) + ": " + @booking.sauna_item.sauna.name + " (" + @booking.sauna_item.name + ")"
			@payment.status = Payment.paid
			@payment.ps_name = "ROBOKASSA"
			@payment.ps_order_id = params['InvId']
			@payment.save

			#money to application balance
			Payment.receive_payment(@payment)		  	
		end
		
		@result = "OK#{params['InvId']}"	
    end
	render 'result', :layout => false	 
  end

  def success
	@booking = Booking.where(:ps_order_id => params['InvId']).first	
	if @booking != nil 
		flash[:success] = :payment_created	
		@sauna = @booking.sauna_item.sauna	
		redirect_to @sauna
	else
		flash[:error] = :intermal_error
		redirect_to :root
	end
  end

  def fail
	@booking = Booking.where(:ps_order_id => params['InvId']).first
	if @booking != nil 
		flash[:error] = :payment_not_created
		@sauna = @booking.sauna_item.sauna	
		redirect_to @sauna	
	else
		flash[:error] = :intermal_error
		redirect_to :root
	end
  end

    def daily_process		
		@count_total, @count_process = Payment.update_payments
		render 'daily_process', :layout => false	
	end
end