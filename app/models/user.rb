class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  before_save :default_values
  has_many :saunas, :dependent => :destroy

  has_secure_password  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates_presence_of :password, :on => :create

  def admin?
    user_type == 1 ? true : false
  end
  
  def owner?
    user_type == 2 ? true : false
  end
  
  private 
	def default_values
		self.user_type = 2 unless self.user_type
	end   
end
