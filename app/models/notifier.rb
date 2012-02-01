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
end

