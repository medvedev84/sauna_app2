class Admin::SaunaItemsController < AdminController
  before_filter :authenticate, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :owner_user, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_sauna, :only => [:index, :new]

	def new                             
		@sauna = Sauna.find(params[:id])
		@sauna_item = SaunaItem.new
	end

	def create
		@sauna = Sauna.find(params[:sauna_item][:sauna_id])
		@sauna_item = @sauna.sauna_items.build(params[:sauna_item])
		if @sauna_item.save
		  flash[:success] = :sauna_item_created		 
		  redirect_to '/admin/sauna/' + @sauna.id.to_s + '/sauna_items'
		else     
		  render 'new'
		end
	end

	def show
		@sauna_item = SaunaItem.find(params[:id])  
		@title = @sauna_item.name 
	end

	def edit
		@sauna_item = SaunaItem.find(params[:id])
		@sauna = @sauna_item.sauna
	end

	def update
		@sauna_item = SaunaItem.find(params[:id])
		@sauna = @sauna_item.sauna
		if @sauna_item.update_attributes(params[:sauna_item])
		  flash[:success] = :sauna_item_updated
		  redirect_to edit_admin_sauna_path(@sauna_item.sauna)
		else
		  render 'edit'
		end
	end 
	
	def destroy
		@sauna_item = SaunaItem.find(params[:id])
		@sauna = @sauna_item.sauna
		SaunaItem.find(params[:id]).destroy
		flash[:success] = :sauna_item_destroyed
		respond_to do |format|
			format.html { redirect_to edit_admin_sauna_path(@sauna) }
			format.js
		end				
	end

	def index    
		@sauna = Sauna.find(params[:id])
		@sauna_items = @sauna.sauna_items	
		respond_to do |format|
			format.html 
			format.js { render :json => @sauna_items.to_json }
		end			
	end	

  private
  
    def correct_sauna
		if !current_user.super_admin?
			@sauna = Sauna.find(params[:id])
			@user = User.find(@sauna.user_id)
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 		
			end				
		end
    end

    def owner_user
		if !current_user.super_admin?
			if !current_user.owner?
				flash[:error] = :access_denied
				redirect_to('/incorrect') 		
			end		
		end
    end

    def correct_user
		if !current_user.super_admin?
			@sauna_item = SaunaItem.find(params[:id])
			@sauna = Sauna.find(@sauna_item.sauna_id)
			@user = User.find(@sauna.user_id)			
			if !current_user?(@user)
				flash[:error] = :access_denied
				redirect_to('/incorrect') 		
			end			
		end
    end


end