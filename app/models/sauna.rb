class Sauna < ActiveRecord::Base
  attr_accessible :name, :phone_number1, :phone_number2, :phone_number3
  
  has_many :sauna_photos,      
           :dependent => :destroy
		   
  has_many :sauna_comments,      
           :dependent => :destroy		   
  
  accepts_nested_attributes_for :sauna_photos, :allow_destroy => true
  
  validates :name, :presence => true,
                   :length   => { :maximum => 50 }

  validates :phone_number1, :presence => true,
                   :length   => { :maximum => 10 }

  has_many :sauna_items, :dependent => :destroy

  belongs_to :user
  has_one :address    
   
  def sauna_min_price    
    @sauna_item = sauna_items.min {|a,b| a.min_price <=> b.min_price }    
    @sauna_item == nil ? 0 : @sauna_item.min_price 
  end
  
  def sauna_max_capacity   
    @sauna_item = sauna_items.max {|a,b| a.capacity <=> b.capacity }    
    @sauna_item == nil ? 0 : @sauna_item.capacity 
  end   
end
