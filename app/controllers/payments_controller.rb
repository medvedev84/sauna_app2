require 'digest/md5'

class PaymentsController < ApplicationController

	def result
		if params["LMI_PAYEE_PURSE"] != nil 
			result_webmoney(params)
		elsif params["InvId"] != nil 
			result_robokassa(params)
		elsif params["tid"] != nil
			result_apay(params)
		else
			# unknown request		
		end 
	end
  
	def success
		if params["LMI_SYS_INVS_NO"] != nil 
			# request from webmoney
			payment = Payment.where(:ps_order_id => params['LMI_SYS_INVS_NO']).first
		elsif params["InvId"] != nil 
			# request from robokassa
			payment = Payment.where(:ps_order_id => params['InvId']).first	
		elsif params["order_id"] != nil 
			# request from robokassa
			payment = Payment.where(:ps_order_id => params['order_id']).first				
		else
			# unknown request
		end
		if payment != nil 
			flash[:success] = :payment_created_short 
			@sauna = payment.booking.sauna_item.sauna	
			redirect_to @sauna
		else
			flash[:error] = :intermal_error
			redirect_to :root
		end
	end

	def fail	  
		flash[:error] = :payment_not_created 
		redirect_to :root
	end

    def daily_process		
		@count_total, @count_process = Payment.update_payments
		render 'daily_process', :layout => false	
	end
	
	def result_apay(params)
		crc = Payment.get_wm_hash(
			params['tid'], 
			params['name'], 
			params['comment'], 
			params['partner_id'], 
			params['service_id'], 
			params['order_id'], 
			params['type'], 
			params['partner_income'], 	
			params['system_income'],
			params['test'],
			"freedom")
		
		@result = crc
		1.times do |x|      
			break if params['check'].blank? || crc.casecmp(params['check']) != 0
			@booking = Booking.where(:id => params['order_id']).first
			break if @booking.blank? || params['system_income'].to_f != SiteSetting.get_booking_fee

			ActiveRecord::Base.transaction do 
				#create payment
				@payment = Payment.new
				@payment.amount = params['partner_income'].to_f 
				@payment.booking_id = @booking.id	
				@payment.description = t(:payment_created_apay) + params['tid'] + ". " + t(:sauna) + ": " + @booking.sauna_item.sauna.name + " (" + @booking.sauna_item.name + ")"
				@payment.status = Payment.paid
				@payment.ps_name = "A1PAY"
				@payment.ps_order_id = params['tid']
				@payment.save

				#money to application balance
				Payment.receive_payment(@payment)		  	
			end
			
			@result = "TRUE"	
		end	
		render 'result', :layout => false	 		
	end
	
	def result_robokassa(params)
		crc = Payment.get_rk_hash(params['OutSum'], 
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
				@payment.description = t(:payment_created_robokassa) + params['InvId'] + ". " + t(:sauna) + ": " + @booking.sauna_item.sauna.name + " (" + @booking.sauna_item.name + ")"
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
	
	def result_webmoney(params)		
		if params["LMI_PAYMENT_AMOUNT"].blank? || params["LMI_PAYEE_PURSE"].blank? || params["LMI_PAYMENT_NO"].blank?
			render :text => 'FAIL', :status => 500,  :layout => false
		elsif params['LMI_PREREQUEST'] != nil && params['LMI_PREREQUEST'].eql?('1') 
				#prerequest
				if Booking.where(:id => params['LMI_PAYMENT_NO']).first
					render :text => 'YES', :status => 200,  :layout => false	 	
				else
					render :text => "Couldn't find booking #{params['LMI_PAYMENT_NO']}", :status => 500, :layout => false
				end		
		else
			#accept request
			crc = Payment.get_wm_hash(
				params['LMI_PAYEE_PURSE'], 
				params['LMI_PAYMENT_AMOUNT'], 
				params['LMI_PAYMENT_NO'], 
				params['LMI_MODE'], 
				params['LMI_SYS_INVS_NO'], 
				params['LMI_SYS_TRANS_NO'], 
				params['LMI_SYS_TRANS_DATE'], 
				"freedom", 			
				params['LMI_PAYER_PURSE'], 	
				params['LMI_PAYER_WM']).upcase   			
			
			@result = "FAIL"			
			1.times do |x|      				
				break if params['LMI_HASH'].blank? || crc.casecmp(params['LMI_HASH']) != 0						
				@booking = Booking.where(:id => params['LMI_PAYMENT_NO']).first
				break if @booking.blank? || params['LMI_PAYMENT_AMOUNT'].to_f != SiteSetting.get_booking_fee

				ActiveRecord::Base.transaction do 
					#create payment
					@payment = Payment.new
					@payment.amount = params['LMI_PAYMENT_AMOUNT'].to_f 
					@payment.booking_id = @booking.id	
					@payment.description = t(:payment_created_webmoney) + params['LMI_SYS_INVS_NO'] + ". " + t(:sauna) + ": " + @booking.sauna_item.sauna.name + " (" + @booking.sauna_item.name + ")"
					@payment.status = Payment.paid
					@payment.ps_name = "WEBMONEY"
					@payment.ps_order_id = params['LMI_SYS_INVS_NO']
					@payment.save

					#money to application balance
					Payment.receive_payment(@payment)		  	
				end				
				@result = "OK"								
			end
			render :text => @result,  :status => 200,  :layout => false	 		
		end
	end
end