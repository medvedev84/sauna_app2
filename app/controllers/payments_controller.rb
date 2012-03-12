require 'digest/md5'

class PaymentsController < ApplicationController
  def result
    crc = Payment::get_hash(params['OutSum'], 
                            params['InvId'], 
                            Payment::MERCHANT_PASS_2,
                            "Shp_item=#{params['Shp_item']}")
    @result = "FAIL"
    1.times do |x|
      break if params['SignatureValue'].blank? || crc.casecmp(params['SignatureValue']) != 0
      @booking = Booking.where(:id => params['Shp_item']).first
      break if @booking.blank? || @booking.payment.price != params['OutSum'].to_f
      @booking.payment.booking_id = params['InvId'].to_i
      @booking.payment.status = Payment::STATUS_OK
      @booking.payment.save
      # ...
      @result = "OK#{params['InvId']}"	  	  
    end
	render 'result', :layout => false	 
  end

  def success
	@booking = Booking.where(:id => params['InvId']).first	
	if @booking != nil 
		flash[:success] = :payment_created	
		@sauna = @booking.sauna	
		redirect_to @sauna
	else
		flash[:error] = :intermal_error
		redirect_to :root
	end
  end

  def fail
	@booking = Booking.where(:id => params['InvId']).first
	if @booking != nil 
		flash[:error] = :payment_not_created
		@sauna = @booking.sauna	
		redirect_to @sauna	
	else
		flash[:error] = :intermal_error
		redirect_to :root
	end
  end
    
end