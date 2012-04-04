class Address < ActiveRecord::Base
  belongs_to :sauna
  belongs_to :city

  validates :street, :presence => true,
                   :length   => { :maximum => 50 }

  def description
    "#{street}, #{building}"     
  end

  def full_description
    "#{city.name}, #{street}, #{building}"     
  end
  
end
