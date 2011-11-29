class SaunaItem < ActiveRecord::Base

  attr_accessible :name, :description, :sauna_type_id, 
		:has_kitchen, :has_restroom, :has_billiards, :has_audio, :has_video, :has_bar,
		:min_price, :capacity, :min_duration
  

  price_regex = /\b[1-9]{1,3}(?:,?[0-9]{3})*\b/i
                                                              
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }

  validates :min_price,  :presence => true,
                         :format   => { :with => price_regex }
   
  belongs_to :sauna
  belongs_to :sauna_type

end
