class PagesController < ApplicationController
   
  def contact
  end

  def about
  end

  def incorrect
  end
  
  def all
	@saunas = Sauna.paginate(:page => params[:page], :per_page => 10)
  end  
end
