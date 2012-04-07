require 'open-uri'
require 'digest/md5'
  
class Payment < ActiveRecord::Base
  belongs_to :booking
  has_many :internal_transaction
  
	#constants
	PAID = 1
	FINISHED = 2

	
  # MERCHANT_URL    = 'https://merchant.roboxchange.com/Index.aspx' 
    MERCHANT_URL = 'http://test.robokassa.ru/Index.aspx'
  # SERVICES_URL    = 'https://merchant.roboxchange.com/WebService/Service.asmx' 
    SERVICES_URL = 'http://test.robokassa.ru/Webservice/Service.asmx'
	
  MERCHANT_LOGIN  = 'gotosauna'
  MERCHANT_PASS_1 = 'password1'
  MERCHANT_PASS_2 = 'password2'
  
  def self.get_currencies(lang = "ru")
    svc_url = "#{SERVICES_URL}/GetCurrencies?MerchantLogin=#{MERCHANT_LOGIN}&Language=#{lang}"
    doc = Nokogiri::XML(open(svc_url))
    doc.xpath("//xmlns:Group").map {|g|{
      'code' => g['Code'],
      'desc' => g['Description'],
      'items' => g.xpath('.//xmlns:Currency').map {|c| {
        'label' => c['Label'], 
        'name' => c['Name']
      }}
    }} if doc.xpath("//xmlns:Result/xmlns:Code").text.to_i == 0
  end
  
  def self.get_payment_methods(lang = "ru")
    svc_url = "#{SERVICES_URL}/GetPaymentMethods?MerchantLogin=#{MERCHANT_LOGIN}&Language=#{lang}"
    doc = Nokogiri::XML(open(svc_url)) 
    doc.xpath("//xmlns:Method").map {|g| {
      'code' => g['Code'],
      'desc' => g['Description']
    }} if doc.xpath("//xmlns:Result/xmlns:Code").text.to_i == 0
  end
  
  def self.get_rates(sum = 1, curr = '', lang="ru")
    svc_url = "#{SERVICES_URL}/GetRates?MerchantLogin=#{MERCHANT_LOGIN}&IncCurrLabel=#{curr}&OutSum=#{sum}&Language=#{lang}"
    doc = Nokogiri::XML(open(svc_url))
    doc.xpath("//xmlns:Group").map {|g| {
      'code' => g['Code'],
      'desc' => g['Description'],
      'items' => g.xpath('.//xmlns:Currency').map {|c| {
        'label' => c['Label'], 
        'name' => c['Name'],
        'rate' => c.xpath('./xmlns:Rate')[0]['IncSum']
      }}
    }} if doc.xpath("//xmlns:Result/xmlns:Code").text.to_i == 0
  end
  
  def self.operation_state(id)
    crc = get_hash(MERCHANT_LOGIN, id.to_s, MERCHANT_PASS_2)
    svc_url = "#{SERVICES_URL}/OpState?MerchantLogin=#{MERCHANT_LOGIN}&InvoiceID=#{id}&Signature=#{crc}&StateCode=80"

    doc = Nokogiri::XML(open(svc_url))
    
    return nil unless doc.xpath("//xmlns:Result/xmlns:Code").text.to_i == 0
    
    state_desc = {
      1   => 'There is no booking with such InvoiceID ',
      5   => 'Just init, no money',
      10  => 'No money, transaction cancelled',
      50  => 'Money received, wait for user decision about payment',
      60  => 'Money have beed returned to user',
      80  => 'Transaction stopped',
      100 => 'Transaction finished',
    }
    
    s = doc.xpath("//xmlns:State")[0]
    code = s.xpath('./xmlns:Code').text.to_i
    state = {
      'code' => code,
      'desc' => state_desc[code],
      'request_date' => s.xpath('./xmlns:RequestDate').text,
      'state_date' => s.xpath('./xmlns:StateDate').text
    }
  end
  
  def self.get_hash(*s)
    Digest::MD5.hexdigest(s.join(':'))
  end
  
	def self.paid 
		PAID
	end
	
	def self.finished 
		FINISHED
	end	  
      
    def self.receive_payment(payment)
		Payment.transfer_money_to_application_balance(payment)
	end
	
    def self.update_payments	
		payments = Payment.joins("LEFT OUTER JOIN bookings on payments.booking_id = bookings.id").where("payments.status = ? and bookings.ends_at <= ?", Payment.paid, DateTime.now - 3)
		count_total = payments.size
		count_process = 0
		payments.each do |payment|
			if Payment.process_payment(payment)
				count_process += 1 
			end			
		end	
		return count_total, count_process		
	end	
	
	private
	
		def self.process_payment(payment)			
			ActiveRecord::Base.transaction do 
				Payment.transfer_money_to_owner_balance(payment)
				Payment.transfer_money_to_site_admin_balance(payment)
				
				payment_to_save = Payment.find(payment.id)
				payment_to_save.status = Payment.finished
				payment_to_save.save	
			end		
		end
		
		def self.transfer_money_to_application_balance(payment)
			#create internal payment to super admin
			super_admin = User.get_super_admin 
			
			# get money from user
			internal_payment_from_user = InternalTransaction.new  	
			internal_payment_from_user.payment_id = payment.id	  
			internal_payment_from_user.amount = -payment.amount	  
			internal_payment_from_user.user_id = 0 # unknown user
			internal_payment_from_user.save

			# give money to application (super admin)
			internal_payment_to_app = InternalTransaction.new  	
			internal_payment_to_app.payment_id = payment.id	  
			internal_payment_to_app.amount = payment.amount	  
			internal_payment_to_app.user_id = super_admin.id 
			internal_payment_to_app.save
			
			#update super_admin's balance
			super_admin.balance_amount += internal_payment_to_app.amount
			super_admin.save			
		end
		
		def self.transfer_money_to_owner_balance(payment)
			#create internal payment to sauna's owner
			super_admin = User.get_super_admin 
			owner = payment.booking.sauna_item.sauna.user
			comission_fee = SiteSetting.get_commission_fee
			amount = payment.amount - comission_fee	 
			
			# get money from application
			internal_payment_from_app = InternalTransaction.new  	
			internal_payment_from_app.payment_id = payment.id	  
			internal_payment_from_app.amount = -amount	  
			internal_payment_from_app.user_id = super_admin.id 
			internal_payment_from_app.save
			
			# give money to owner
			internal_payment_to_owner = InternalTransaction.new  	
			internal_payment_to_owner.payment_id = payment.id	  
			internal_payment_to_owner.amount = amount	  
			internal_payment_to_owner.user_id = owner.id	  
			internal_payment_to_owner.save

			#update owner's balance
			owner.balance_amount += internal_payment_to_owner.amount
			owner.save			
		end
			
		def self.transfer_money_to_site_admin_balance(payment)
			#create internal payment to site admin
			super_admin = User.get_super_admin
			site_admin = User.get_site_admin
			amount = SiteSetting.get_commission_fee
			
			# get money from application
			internal_payment_from_app = InternalTransaction.new  	
			internal_payment_from_app.payment_id = payment.id	  
			internal_payment_from_app.amount = -amount	  
			internal_payment_from_app.user_id = super_admin.id 
			internal_payment_from_app.save
			
			# give money to city admin
			internal_payment_to_site_admin = InternalTransaction.new  	
			internal_payment_to_site_admin.payment_id = payment.id	  
			internal_payment_to_site_admin.amount = amount	  
			internal_payment_to_site_admin.user_id = site_admin.id	  
			internal_payment_to_site_admin.save
			
			#update owner's balance
			site_admin.balance_amount += internal_payment_to_site_admin.amount
			site_admin.save		
		end		
end