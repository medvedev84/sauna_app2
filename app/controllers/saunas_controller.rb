class SaunasController < ApplicationController
  before_filter :authenticate, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user, :only => :new

  def new                             
    @user = User.find(params[:user_id])
    @address = Address.new
    @sauna = Sauna.new
	5.times { @sauna.sauna_photos.build }
  end

  def create
    @user = User.find(params[:sauna][:user_id])
    @sauna = @user.saunas.build(params[:sauna])
    @address = Address.new(params[:sauna][:address])
    
    if @address.save 
		if @sauna.save 
		  @address.sauna_id = @sauna.id
		  @address.save
		  		  		   
		  h = params[:sauna][:sauna_photos_attributes]
		  h.each do |key, value|
		    @sauna_photo = SaunaPhoto.new(value)
			@sauna_photo.sauna_id = @sauna.id
			@sauna_photo.save
		  end

		  flash[:success] = :sauna_created
		  redirect_to users_path
		else     
		  render 'new'
		end	
    else
      render 'new'
	end
  end                   

  def edit
    @sauna = Sauna.find(params[:id])
    @address = @sauna.address
	5.times { @sauna.sauna_photos.build }
  end

  def update
    @sauna = Sauna.find(params[:id])
    @address = @sauna.address
	
	if @address.update_attributes(params[:sauna][:address])
		if @sauna.update_attributes(params[:sauna])	

		  h = params[:sauna][:sauna_photos_attributes]
		  h.each do |key, value|		    
		    @sauna_photo = SaunaPhoto.new(value)
			@sauna_photo.sauna_id = @sauna.id
			@sauna_photo.save
		  end
		  
		  flash[:success] = :sauna_updated
		  redirect_to @sauna.user
		else
		  render 'edit'
		end 
	else
      render 'edit'
    end
  end

  def show
    # ugly hack for back url
    if /address_district_id_eq/ =~ request.env['HTTP_REFERER']
		@back_url = request.env['HTTP_REFERER']
	end    
    @sauna = Sauna.find(params[:id])
	@sauna_items =  @sauna.sauna_items
	@sauna_comment = SaunaComment.new
  end
          
  def index
    h = params[:q]
	if h != nil
		h.delete_if {|key, value| key == "sauna_items_has_kitchen_eq" && value == "0" } #if kitchen is not important, don't use that criteria
		h.delete_if {|key, value| key == "sauna_items_has_restroom_eq" && value == "0" } #if restroom is not important, don't use that criteria
		h.delete_if {|key, value| key == "sauna_items_has_billiards_eq" && value == "0" } #if billiards is not important, don't use that criteria
		h.delete_if {|key, value| key == "sauna_items_has_audio_eq" && value == "0" } #if audio is not important, don't use that criteria
		h.delete_if {|key, value| key == "sauna_items_has_video_eq" && value == "0" } #if video is not important, don't use that criteria
		h.delete_if {|key, value| key == "sauna_items_has_bar_eq" && value == "0" } #if bar is not important, don't use that criteria
	end
	@q = Sauna.search(h)	
	if mobile_device? 
		@saunas = @q.result(:distinct => true)
		if h != nil 			
			render 'search'
		else
			render 'index'
		end		
	else
		@saunas = @q.result(:distinct => true).paginate(:page => params[:page], :per_page => 10)	
	end	
  end

  def destroy
    Sauna.find(params[:id]).destroy
    flash[:success] = "Sauna destroyed."
  end

	private

		def correct_user
		  @sauna = Sauna.find(params[:id])
		  @user = User.find(@sauna.user_id)
		  redirect_to(root_path) unless current_user?(@user)
		end	

end
