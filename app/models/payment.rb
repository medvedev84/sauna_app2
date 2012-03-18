require 'open-uri'
require 'digest/md5'
  
class Payment < ActiveRecord::Base
  belongs_to :booking
  has_many :internal_payment
  
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
  
end