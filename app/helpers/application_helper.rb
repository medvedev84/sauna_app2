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

	def get_all_cities
		@cities = City.all		
		@cities_for_dropdown = []
		@cities.each do |city|
			@cities_for_dropdown = @cities_for_dropdown << [city.name, city.id]
		end
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
	
	def get_all_sauna_items
		@sauna_items = SaunaItem.joins('LEFT OUTER JOIN saunas ON saunas.id = sauna_items.sauna_id').order("sauna_id ASC, id DESC")
		@sauna_items_for_dropdown = []
		@sauna_items.each do |sauna_item|
			@sauna_items_for_dropdown = @sauna_items_for_dropdown << [sauna_item.name, sauna_item.id, {:class => sauna_item.sauna.id}]
		end	
	end  	
	
	def get_statuses		
		@statuses_for_dropdown = []	
		@statuses_for_dropdown = @statuses_for_dropdown << [t(:status_approve), ExternalPayment.approve]
		@statuses_for_dropdown = @statuses_for_dropdown << [t(:status_decline), ExternalPayment.decline]		
	end  	
	
	def get_saunas_by_user(user_id)
		@saunas = Sauna.where("user_id = ?", user_id).order("user_id ASC, id DESC")
		@saunas_for_dropdown = []
		@saunas.each do |sauna|
			@saunas_for_dropdown = @saunas_for_dropdown << [sauna.name, sauna.id, {:class => sauna.user.id}]
		end	
	end 	
	
	def get_sauna_items_by_user(user_id)
		@sauna_items = SaunaItem.joins('LEFT OUTER JOIN saunas ON saunas.id = sauna_items.sauna_id').where("saunas.user_id = ?", user_id).order("sauna_id ASC, id DESC")
		@sauna_items_for_dropdown = []
		@sauna_items.each do |sauna_item|
			@sauna_items_for_dropdown = @sauna_items_for_dropdown << [sauna_item.name, sauna_item.id, {:class => sauna_item.sauna.id}]
		end	
	end	
	
	def get_all_coupon_urls
		@coupon_urls = CouponUrl.order("city_id ASC, id DESC")
		@coupon_urls_for_dropdown = []
		@coupon_urls.each do |coupon_url|
			@saunas_for_dropdown = @coupon_urls_for_dropdown << [coupon_url.name, coupon_url.id, {:class => coupon_url.city.id}]
		end	
	end  	
end
