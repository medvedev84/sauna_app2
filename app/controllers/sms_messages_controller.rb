class SmsMessagesController < ApplicationController
	
	def status   
		h = params[:data]
		
		if h != nil
			h.each do |key, value| 
				@lines = value.split("\n")
	
				if lines[0] == "sms_status" 
					sms_id = lines[1]
					status = lines[2]
					
					sms  = SmsMessage.where("sms_number = ?", sms_id).first	
					sms.update_attributes(:status => status)	
				end
				
			end
		end
		
		@status = 100
		
		render 'status', :layout => false
	end
end