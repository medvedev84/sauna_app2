class Admin::ExternalPaymentsController < AdminController
	include ApplicationHelper
	
	before_filter :authenticate
	before_filter :super_admin_user, :only => [:update]
	before_filter :not_admin_user
	
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
		@external_payments = @q.result(:distinct => true).order("created_at DESC").page(params[:page]).per(10)			
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
		ActiveRecord::Base.transaction do 
			if @external_payment.update_attributes(params[:external_payment])
				transfer_money_from_owner_balance(@external_payment)
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
	
	private
	
		def transfer_money_from_owner_balance(external_payment)			
			# get money from owner
			owner = external_payment.user 
			
			internal_payment_from_owner = InternalTransaction.new  	
			internal_payment_from_owner.external_payment_id = external_payment.id	  
			internal_payment_from_owner.amount = -external_payment.amount	  
			internal_payment_from_owner.user_id = external_payment.user.id 
			internal_payment_from_owner.save
			
			# give money to outer payment system
			internal_payment_to_ps = InternalTransaction.new  	
			internal_payment_to_ps.external_payment_id = external_payment.id	  
			internal_payment_to_ps.amount = external_payment.amount	  
			internal_payment_to_ps.user_id = 0	  
			internal_payment_to_ps.save

			#update owner's balance
			owner.balance_amount -= internal_payment_to_ps.amount
			owner.save			
		end		
		
		def not_admin_user
			if current_user.admin? 
				#admin should not have access to external_payments at all
				flash[:error] = :access_denied
				redirect_to('/incorrect') 
			end		
		end
end