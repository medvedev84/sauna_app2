class Notifier < ActionMailer::Base
	default :from => "no-reply@go-to-sauna.ru"
	
	# send a signup email to the user, pass in the user object that contains the user’s email address
	def welcome_email(user)
		@user = user
		mail( :to => user.email, :subject => "Confirm registration")
	end	
		
	def update_user_email(user)
		@user = user
		mail( :to => user.email, :subject => "Your registration data has been updated succesfully")
	end		
	
	# send a signup email to the user, pass in the user object that contains the user’s email address
	def signup_email(user)
		mail( :to => user.email, :subject => "Thanks for signing up" )
	end
	
	# send a signup email to the user, pass in the user object that contains the user’s email address
	def booking_created_email_to_owner(booking)
		@booking = booking
		mail( :to => booking.sauna_item.sauna.user.email, :subject => t(:booking_created_to_owner) )
	end	
	
	# send a signup email to the user, pass in the user object that contains the user’s email address
	def booking_created_email_to_customer(booking)
		@booking = booking
		mail( :to => booking.email, :subject => t(:booking_created_to_client) )
	end	
	
	# send a email to admin
	def external_payment_created_email_to_admin(external_payment)
		@external_payment = external_payment
		mail( :to => "k.p.medvedev@gmail.com", :subject => "New external payment has been created" )
	end		
end

