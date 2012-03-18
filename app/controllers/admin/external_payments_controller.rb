class Admin::ExternalPaymentsController < AdminController
	include ApplicationHelper
	
	def create
		@external_payment = ExternalPayment.new(params[:external_payment])
		@external_payment.user = current_user
		@external_payment.status = ExternalPayment.init
		
		if @external_payment.amount > current_user.balance_amount
			@external_payment.errors["test"] = t(:no_money)				
			render 'new'
		else
			if @external_payment.save							
				# Deliver the email to owner and customer
				#Notifier.booking_created_email_to_owner(@booking).deliver
				#Notifier.booking_created_email_to_customer(@booking).deliver
				respond_to do |format|
					format.html			
					format.js
				end
			else    
				@external_payment.errors
				render 'new'
			end			
		end
			
	end		
	
	def index 	
		get_statuses
		get_all_owners	
		
		@external_payment = ExternalPayment.new
		h = params[:q]
		@q = ExternalPayment.search(h)									
		@current_page_number = params[:page] != nil ? params[:page] : 1 
		@external_payments = @q.result(:distinct => true).order("created_at DESC").page(params[:page]).per(5)			
		respond_to do |format|
			format.html { render 'index' }
			format.js
		end				
	end	
	
	def show		
		@external_payment = ExternalPayment.find(params[:id])
		respond_to do |format|
		  format.js 
		end
	end
	
	def update
		@external_payment = ExternalPayment.find(params[:external_payment][:id])
		@external_payment.status = ExternalPayment.approve
		if @external_payment.update_attributes(params[:external_payment])
			respond_to do |format|
				format.html			
				format.js
			end	
		else
			@external_payment.errors
			render 'edit'
		end
	end
end