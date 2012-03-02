require 'digest/md5'

class Sms
  
  def self.send(to,text,from = '',express = 0,time = '')
    test = ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'demo' ? '1' : '0'	
    token = get_token
    sig = Digest::MD5::hexdigest(conf['password']+token)
    encoding='windows-1251'
    code, sms_id = 0
    if can_send? && check(token) == "100"
      url = ["http://sms.ru/sms/send",
             "?to=#{to}",
             "&text=#{text}",
             "&encoding=#{encoding}",
             "&from=#{from}",
             "&time=#{time}",
             "&login=#{conf['login']}",
             "&token=#{token}",
             "&sig=#{sig}",
             "&express=#{express}",
             "&test=#{test}"
             ].join
      http = Net::HTTP.new('www.sms.ru')
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      if response.code == '200'
        sp = response.body.split("\n")
        code = sp[0]
        sms_id = sp[1] if code == '100'
      end
    end
    #return code,sms_id
	return sms_id
  end

  def self.status(sms_id)
    url = "http://sms.ru/sms/status?api_id=#{conf['api_id']}&id=#{sms_id}"
    http = Net::HTTP.new('www.sms.ru')
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    code = 0
    if response.code == '200'
      code = response.body
    end
    return code
  end

  def self.check(token)
    sig = Digest::MD5::hexdigest(conf['password']+token)
    url = "http://sms.ru/auth/check?login=#{conf['login']}&sig=#{sig}&token=#{token}"
    http = Net::HTTP.new('www.sms.ru')
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    code = 0
    if response.code == '200'
      code = response.body
    end
    return code
  end

  def self.get_token
    url = 'http://sms.ru/auth/get_token'
    http = Net::HTTP.new('www.sms.ru')
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    token = ''
    if response.code == '200'
      token = response.body
    end
    return token
  end

  def self.get_limit
    url = 'http://sms.ru/my/limit?api_id='+conf['api_id']
    http = Net::HTTP.new('www.sms.ru')
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    code = send_limit = sended = 0
    if response.code == '200'
      sp = response.body.split("\n")
      code = sp[0]
      if code == '100'
        send_limit = sp[1].to_i
        sended = sp[2].to_i
      end
    end
    return code, send_limit, sended
  end

  def self.get_balance
    url = 'http://sms.ru/my/balance?api_id='+conf['api_id']
    http = Net::HTTP.new('www.sms.ru')
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    code = balance = 0
    if response.code == '200'
      sp = response.body.split("\n")
      code = sp[0]
      if sp[0] == '100'
        balance = sp[1].to_f
      end
    end
    return code,balance
  end

  private

  def self.conf	
    APP_CONFIG['sms_ru']
  end

  def self.can_send?
    res = false
    limit? && balance?
  end

  def self.limit?
    code, balance = get_balance
    code == '100' && balance > 1
  end

  def self.balance?
    res = false
    code, send_limit, sended = get_limit
    code == '100' && sended < send_limit
  end
end