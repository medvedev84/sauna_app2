class User < ActiveRecord::Base
  attr_accessible :name, :email, :user_type, :password, :password_confirmation, :wmr_purse
  #before_save :default_values
  has_many :saunas, :dependent => :destroy
  has_many :internal_payments, :dependent => :destroy
  has_many :external_payments, :dependent => :destroy
  has_secure_password  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :wmr_purse, :presence => true,
                   :length   => { :maximum => 15 }
  validates_presence_of :password, :on => :create

  def super_admin?
    user_type == 1 ? true : false
  end
  
  def admin?
    user_type == 2 ? true : false
  end
  
  def owner?
    user_type == 3 ? true : false
  end
  
  def tester?
    user_type == 4 ? true : false
  end  
  
  def money_in_reserve
	sql = "select sum(amount) as amount from payments 
			left outer join bookings on bookings.id = payments.booking_id 
			left outer join sauna_items on sauna_items.id = bookings.sauna_item_id 
			left outer join saunas on saunas.id = sauna_items.sauna_id 
			where status = " + Payment.paid.to_s + " and saunas.user_id = " + self.id.to_s
	sql_result = ActiveRecord::Base.connection.execute(sql)
	@money_in_reserve = sql_result[0]["amount"]
  end  
  
  def self.get_super_admin
	# TODO: return super_admin
	User.find(1)
  end
  
  def self.get_site_admin
	# TODO: return site_admin
	User.find(4)
  end  
	
  private 
	def default_values
		self.user_type = 3 unless self.user_type
	end   
end
