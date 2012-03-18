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
		break if @booking.blank? || params['OutSum'].to_f != 1000

		ActiveRecord::Base.transaction do 
			#create payment
			@payment = Payment.new
			@payment.amount = params['OutSum'].to_f 
			@payment.booking_id = @booking.id	
			@payment.description = "Payment for booking #" + @booking.id.to_s + " created at " + @booking.created_at.to_s
			@payment.status = "Payment success"
			@payment.save

			#update booking
			@booking.ps_order_id = params['InvId'].to_i
			@booking.save			  

			#transfer money
			transfer_money_to_owner_balance(@booking)
			transfer_money_to_admin_balance(@booking)		
		end
		
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

	private
		
		def transfer_money_to_owner_balance(booking)
		  #create internal payment to sauna's owner
		  owner = booking.sauna.user
		  payment = booking.payment
		  internal_payment = InternalPayment.new  	
		  internal_payment.payment_id = payment.id	  
		  internal_payment.amount =  payment.amount - 50	  
		  internal_payment.user_id = owner.id	  
		  internal_payment.save
		  
		  #update owner's balance
		  owner.balance_amount += internal_payment.amount
		  owner.save			
		end
		
		def transfer_money_to_admin_balance(booking)
			#create internal payment to super admin
			super_admin = User.find(1)
			payment = booking.payment
			internal_payment = InternalPayment.new  	
			internal_payment.payment_id = payment.id	  
			internal_payment.amount =  50	  
			internal_payment.user_id = super_admin.id	  
			internal_payment.save
			#update owner's balance
			super_admin.balance_amount += internal_payment.amount
			super_admin.save		
		end		
    
end