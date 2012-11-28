require 'vkontakte'

class VkController < ApplicationController
	
	def get_users
		thread = Thread.new{run_get_users()}
		
		@response = "Adding users. Thread has been started"
		render 'get_users', :layout => false
	end
	
	def run_get_users
		vk = Vkontakte::Client.new('3205140')		
		
		# izhevsk
		vk.login!('+79124629396', 'mkp01031984', scope = 'friends')						
		
		# chelni
		# vk.login!('+66835304827', 'sauna2012', scope = 'friends')						
				
		count_offset = 1200 				
		#count_offset = 1000 				
			
		# get 1000 members			
		 response_content = vk.api.groups_getMembers(gid: "izhnews", count: 100, offset: count_offset)												
		#response_content = vk.api.groups_getMembers(gid: "nabchel", count: 100, offset: count_offset)										
		
		# sleep for one second to prevent 'too many requests' error
		sleep(1)
		
		# convert response to array
		objArray = response_content["users"].to_a
		
		# go throw 1000 members 
		objArray.each do |user|	

			# send invite request
			vk.api.subscriptions_follow(uid: user.to_s.strip)		
			
			# sleep for 1/3 second to prevent 'too many requests' error
			sleep(1)	
		end	
		
	end
	
	def run_get_users_in_loop
		vk = Vkontakte::Client.new('3205140')		
		vk.login!('+79124629396', 'sauna2012', scope = 'friends')						
		
		# get information about the group
		response_content = vk.api.groups_getById(gid: "izhnews", fields: "members_count")		
		
		count_total = response_content[0]["members_count"]
		count_step = count_total / 1000
		count_offset = 0 				
		
		# go throw all members by step (each step equals to 1000 members)
		for i in 1..count_step 			
	
	
			# get 1000 members			
			response_content = vk.api.groups_getMembers(gid: "izhnews", count: 1000, offset: count_offset)										
			
			# sleep for one second to prevent 'too many requests' error
			sleep(1)
			
			# convert response to array
			objArray = response_content["users"].to_a
			
			# go throw 1000 members 
			objArray.each do |user|	

				# send invite request
				vk.api.subscriptions_follow(uid: user.to_s.strip)		
				
				# sleep for 1/3 second to prevent 'too many requests' error
				sleep(1)	
			end	
		
			# iterate offset for next step
			count_offset = i * 1000
		end	
	end
		
		
	def get_vk_sign(*s)
		Digest::MD5.hexdigest(s.join(''))	
	end	
end