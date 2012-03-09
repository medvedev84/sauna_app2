require 'digest/md5'

class PaymentsController < ApplicationController
  
  def pay
    @order = Booking.where(:id => params[:id]).first
    unless @order.blank? && @order.payment.blank?
      @pay_desc = Hash.new
      @pay_desc['mrh_url']   = Payment::MERCHANT_URL
      @pay_desc['mrh_login'] = Payment::MERCHANT_LOGIN
      @pay_desc['mrh_pass1'] = Payment::MERCHANT_PASS_1
      @pay_desc['inv_id']    = 0
      @pay_desc['inv_desc']  = @order.description
      @pay_desc['out_summ']  = 1000
      @pay_desc['shp_item']  = @order.id
      @pay_desc['in_curr']   = "WMRM"
      @pay_desc['culture']   = "ru"
      @pay_desc['encoding']  = "utf-8"
      @pay_desc['crc'] = Payment::get_hash(@pay_desc['mrh_login'], 
                                           @pay_desc['out_summ'],
                                           @pay_desc['inv_id'], 
                                           @pay_desc['mrh_pass1'], 
                                           "Shp_item=#{@pay_desc['shp_item']}")     
    end
	
  end

  def result
    crc = Payment::get_hash(params['OutSum'], 
                            params['InvId'], 
                            Payment::MERCHANT_PASS_2,
                            "Shp_item=#{params['Shp_item']}")
    @result = "FAIL"
    1.times do |x|
      break if params['SignatureValue'].blank? || crc.casecmp(params['SignatureValue']) != 0
      @booking = Booking.where(:id => params['Shp_item']).first
      break if @booking.blank? || @booking.payment.price != params['OutSum'].to_f
      @booking.payment.booking_id = params['InvId'].to_i
      @booking.payment.status = Payment::STATUS_OK
      @booking.payment.save
      # ...
      @result = "OK#{params['InvId']}"
    end
  end

  def success
	flash[:success] = :payment_created	
	@booking = Booking.where(:id => params['InvId']).first
	@sauna = @booking.sauna	
	redirect_to @sauna
  end

  def fail
	flash[:error] = :payment_not_created
	@booking = Booking.where(:id => params['InvId']).first
	@sauna = @booking.sauna	
	redirect_to @sauna	
  end
    
end