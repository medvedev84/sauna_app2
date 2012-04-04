class Admin::SaunaCommentsController < AdminController
	before_filter :authenticate
	before_filter :correct_user
	
	def destroy
		@sauna_comment = SaunaComment.find(params[:id])		
		@sauna = @sauna_comment.sauna
		SaunaComment.find(params[:id]).destroy
		flash[:success] = :sauna_comment_destroyed
		respond_to do |format|
			format.html { redirect_to edit_admin_sauna_path(@sauna) }
			format.js
		end		
	end  
	
	def index    
		@sauna = Sauna.find(params[:id])
		@sauna_comments = @sauna.sauna_comments						
	end		
	
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