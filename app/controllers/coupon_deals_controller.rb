require 'nokogiri'
require 'open-uri'

class CouponDealsController < ApplicationController
	
	def index 	
		@coupon_deals = CouponDeal.all											
	end
	
	def daily_process 
		CouponDeal.delete_all
		coupon_urls = CouponUrl.all
		coupon_urls.each do |url|
			doc = Nokogiri::HTML(open(url.site_url))
			doc.css('.action_item').each_with_index do |div, i|
			  div_content = div.css('.header a').inner_html		 
			  if div_content.include?(t(:saun)) || div_content.include?(t(:banya)) || div_content.include?(t(:banei))
				@coupon_deal = CouponDeal.new
				@coupon_deal.coupon_url_id = url.id
				@coupon_deal.description = div_content
				@coupon_deal.deal_url = div.css('.header a').attr("href").to_s
				@coupon_deal.image_url = div.css('.img img').attr("src").to_s
				@coupon_deal.price_old = div.css('.price_old span').inner_html.delete(' ').strip
				@coupon_deal.price_new = div.css('.price_new span').inner_html.delete(' ').strip
				@coupon_deal.save						
			  end
			end			
		end
		render 'daily_process', :layout => false				
	end
		
end