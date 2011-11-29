class Address < ActiveRecord::Base
  belongs_to :sauna
  belongs_to :city

  validates :street, :presence => true,
                   :length   => { :maximum => 50 }
  validates :building, :presence => true,
                   :length   => { :maximum => 5 }

  def description
    "#{street}, #{building}"     
  end

  def full_description
    "#{city.name}, #{street}, #{building}"     
  end
  
end
