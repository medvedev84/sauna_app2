require 'digest/md5'

class PaymentsController < ApplicationController
  def result
    @result = "FAIL"
    1.times do |x|      
      @booking = Booking.where(:id => params['Shp_item']).first
      break if @booking.blank? || params['OutSum'].to_f != 1000
      #create payment
	  @payment = Payment.new
	  @payment.price = params['OutSum'].to_f 
	  @payment.booking_id = @booking.id	
	  @payment.description = "Payment for booking #" + @booking.id.to_s + " created at " + @booking.created_at.to_s
      @payment.status = "Payment success"
      @payment.save
	  #update booking
	  @booking.ps_order_id = params['InvId'].to_i
	  @booking.save		
      @result = "OK#{params['InvId']}"	  	  
    end
	render 'result', :layout => false	 
  end

  def success
	@booking = Booking.where(:ps_order_id => params['InvId']).first	
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
	@booking = Booking.where(:ps_order_id => params['InvId']).first
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