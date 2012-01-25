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
	@saunas = @q.result(:distinct => true).paginate(:page => params[:page], :per_page => 10)
	#@saunas = Sauna.paginate(:page => params[:page], :per_page => 10)
  end  
end
