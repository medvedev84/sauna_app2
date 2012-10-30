require 'paperclip_processors/watermark'

class SaunaPhoto < ActiveRecord::Base
  belongs_to :sauna
  
  has_attached_file :photo, 
					:processors => [:watermark],
                    :styles => {
                      :thumb => ["100x100", :jpg],
					  :size200 => ["200x200", :jpg],
					  :size300 => ["300x200", :jpg],
					  :size600 => ["600x400", :jpg],
					  :pagesize => {
						:geometry => '800x600',
						:format => :jpg ,
						:watermark_path => "#{Rails.root}/public/images/watermark.png",
						:position => 'Center'
					  }						  
                    },
                    :default_style => :pagesize,
					:storage => :s3,
					:s3_credentials => "#{Rails.root}/config/s3.yml",
					:path => ":attachment/:id/:style.:extension",
					:bucket => "go-to-sauna"					
		
	attr_accessor :size
		
	def photo_url
		"#{photo.url}"   
	end																		
	
	def photo_url_thumb
		case self.size
			when "size200"
				"#{photo.url(:size200)}" 
			when "size300"
				"#{photo.url(:size300)}"
			when "size600"
				"#{photo.url(:size600)}"
			when "original"
				"#{photo.url(:original)}"				
			else
				"#{photo.url(:thumb)}"
		end						   
	end	
	
end
