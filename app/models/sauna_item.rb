class SaunaItem < ActiveRecord::Base
  attr_accessible :name, :description, :sauna_type_id, 
		:has_kitchen, :has_restroom, :has_billiards, 
		:has_audio, :has_video, :has_bar,
		:has_pool, :has_mangal, :has_veniki,
		:min_price, :capacity, :min_duration
                                                              
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
   
  
  validates_numericality_of :capacity, :only_integer => true, :message => :must_be_integer  
  validates_numericality_of :min_price, :only_integer => true, :message => :must_be_integer
  validates_numericality_of :min_duration, :only_integer => true, :message => :must_be_integer

	belongs_to :sauna
	belongs_to :sauna_type
	has_many :bookings, :dependent => :destroy  
  
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name
    }    
  end  
end
