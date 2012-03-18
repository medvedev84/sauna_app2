module ApplicationHelper
	def delete_image
		image_tag ("delete.png")
	end

	def edit_image
		image_tag ("edit.png")
	end  

	def create_image
		image_tag ("create.png")
	end   

	def get_all_owners
		@owners = User.where("user_type = 3")		
		@owners_for_dropdown = []
		@owners.each do |user|
			@owners_for_dropdown = @owners_for_dropdown << [user.name, user.id]
		end
	end
	
	def get_all_saunas
		@saunas = Sauna.order("user_id ASC, id DESC")
		@saunas_for_dropdown = []
		@saunas.each do |sauna|
			@saunas_for_dropdown = @saunas_for_dropdown << [sauna.name, sauna.id, {:class => sauna.user.id}]
		end	
	end  
	
	def get_statuses		
		@statuses_for_dropdown = []	
		@statuses_for_dropdown = @statuses_for_dropdown << [t(:status_approve), ExternalPayment.approve]
		@statuses_for_dropdown = @statuses_for_dropdown << [t(:status_decline), ExternalPayment.decline]		
	end  	
end
