desc "This task is called by the Heroku scheduler add-on"
task :daily_payment_process => :environment do
    puts "Updating payments..."
	Payment.update_payments		
    puts "done."
end