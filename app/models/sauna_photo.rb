#require 'paperclip_processors/watermark'

class SaunaPhoto < ActiveRecord::Base
  belongs_to :sauna
  has_attached_file :photo, #:processors => [:watermark],
                    :styles => {
                      :thumb => ["100x100", :jpg],
					  :pagesize => ["100x100", :jpg]
#					  :pagesize => {
#						:geometry => '500x400',
#						:format => :jpg,
#						:watermark_path => "#{Rails.root}/public/images/watermark.png",
#						:position => 'Center'
#					  }						  
                    },
                    :default_style => :pagesize
					
  attr_accessor :watermark					
end
