class Admin::SaunasController < AdminController
	before_filter :authenticate, :only => [:new, :edit, :update, :destroy]
	before_filter :correct_user, :only => [:edit, :update, :destroy]
	#before_filter :admin_user, :only => :new
	
	include SaunasHelper
	
	def new                             
		@user = User.find(params[:user_id])
		@address = Address.new
		@sauna = Sauna.new
		5.times { @sauna.sauna_photos.build }
		get_all_cities
		get_districts_for_edit_form	
	end

	def create
		get_all_cities
		get_districts_for_edit_form	
		
		@user = User.find(params[:sauna][:user_id])
		@sauna = @user.saunas.build(params[:sauna])
		@address = Address.new(params[:sauna][:address])
		
		if @address.save 
			if @sauna.save 
				@address.sauna_id = @sauna.id
				@address.save
				
				h = params[:sauna][:sauna_photos_attributes]	
				
				if h != nil 
					h.each do |key, value|	
						@sauna_photo = SaunaPhoto.new(:photo => h[key][:photo])
						if @sauna_photo.photo_file_size != nil
							@sauna_photo.sauna_id = @sauna.id
							@sauna_photo.description = h[key][:description]						
							@sauna_photo.save
						end
					end
				end			

				flash[:success] = :sauna_created
				
				if current_user.super_admin?
					redirect_to edit_admin_sauna_path(@sauna)
				else
					redirect_to admin_saunas_path
				end
				
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
		@user = @sauna.user
		5.times { @sauna.sauna_photos.build }
		get_all_cities
		get_districts_for_edit_form	
	end
  
	def show
		@sauna = Sauna.find(params[:id])		
		@address = @sauna.address		
	end  

	def update
		get_all_cities
		get_districts_for_edit_form	
		
		@sauna = Sauna.find(params[:id])
		@address = @sauna.address

		if @address.update_attributes(params[:sauna][:address])
			if @sauna.update_attributes(params[:sauna])	
				h = params[:sauna][:sauna_photos_attributes]
				
				if h != nil 
					h.each do |key, value|	
						@sauna_photo = SaunaPhoto.new(:photo => h[key][:photo])
						if @sauna_photo.photo_file_size != nil
							@sauna_photo.sauna_id = @sauna.id
							@sauna_photo.description = h[key][:description]						
							@sauna_photo.save
						end
					end
				end				
								
				flash[:success] = :sauna_updated
				redirect_to edit_admin_sauna_path(@sauna)
			else
				render 'edit'
			end 
		else
			render 'edit'
		end
	end
          
	def index    
		@user = current_user		
		h = params[:q]
		@q = Sauna.search(h)	
		if h != nil			
			@saunas = @q.result(:distinct => true)
		else			
			@saunas = current_user.saunas
		end	
		@current_page_number = params[:page] 
		@saunas = @saunas.page(params[:page]).per(5)		
		@booking = Booking.new		
	end

	def destroy
		@sauna = Sauna.find(params[:id])
		@user = @sauna.user
		Sauna.find(params[:id]).destroy
		flash[:success] = :sauna_destroyed
		if current_user.super_admin?
			redirect_to admin_user_path(@user)
		else
			redirect_to admin_saunas_path
		end		
	end

	private

	def correct_user
		if !current_user.super_admin? 
			@sauna = Sauna.find(params[:id])
			@user = User.find(@sauna.user_id)			
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 			
			end
		end
	end	

end
