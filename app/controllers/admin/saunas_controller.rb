class Admin::SaunasController < AdminController
	before_filter :authenticate
	before_filter :correct_user, :only => [:edit, :update, :destroy]
	before_filter :not_site_admin, :only => [:index]
	
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
		
		# check if booking is possible
		if params[:sauna][:is_booking] != "0" && @user.wmr_purse.empty?
			@sauna.errors["is_booking"] = t (:wmr_is_required)
			render 'new'	
		else
			# if booking is absent or booking is possible, then save sauna
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
					
					redirect_to edit_admin_sauna_path(@sauna)
					
				else     
					render 'new'
				end	
			else
				render 'new'
			end		
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

		if params[:sauna][:is_booking] != "0" && @user.wmr_purse.empty?
			@sauna.errors["is_booking"] = t (:wmr_is_required)
			render 'edit'	
		else
			if @address.update_attributes(params[:sauna][:address])
				if @sauna.update_attributes(params[:sauna])										
					flash[:success] = :sauna_updated
					redirect_to edit_admin_sauna_path(@sauna)
				else
					render 'edit'
				end 
			else
				render 'edit'
			end		
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
		@current_page_number = params[:page] != nil ? params[:page] : 1		
		@saunas = @saunas.page(params[:page]).per(10)		
		@booking = Booking.new		
		
		respond_to do |format|
			format.html 
			format.js
		end	
		
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
			if current_user.admin? 
				#admin should not have access to saunas at all
				flash[:error] = :access_denied
				redirect_to('/incorrect') 
			else
				@sauna = Sauna.find(params[:id])
				@user = User.find(@sauna.user_id)			
				if !current_user?(@user)
					flash[:error] = :access_denied
					redirect_to('/incorrect') 			
				end			
			end
		end
	end	
	
	def not_site_admin
		if current_user.admin? 
			#site_admin should not have access to saunas at all
			flash[:error] = :access_denied
			redirect_to('/incorrect') 	
		end
	end		

end
