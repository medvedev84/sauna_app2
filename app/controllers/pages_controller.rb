class PagesController < ApplicationController
  
  def contact
  end

  def about
  end

  def incorrect
  end
  
  def all
	h = params[:q]
	@q = Sauna.search(h)	
	if (mobile_device? || touch_device? ) 
		@saunas = @q.result(:distinct => true)		
	else	
		@current_page_number = params[:page] != nil ? params[:page] : 1		
		@saunas = @q.result(:distinct => true).page(params[:page]).per(5)	
		respond_to do |format|
			format.html 
			format.js
		end		
	end		
  end  
end
