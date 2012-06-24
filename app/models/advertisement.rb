class Advertisement < ActiveRecord::Base
  belongs_to :city  
  
  has_attached_file :photo, 		
                    :styles => {
                      :thumb => ["50x50", :jpg],
					},
                    :default_style => :thumb,
					:storage => :s3,
					:s3_credentials => "#{Rails.root}/config/s3.yml",
					:path => ":attachment/:id/:style.:extension",
					:bucket => "go-to-sauna"	  
end