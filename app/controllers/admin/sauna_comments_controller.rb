class Admin::SaunaCommentsController < ApplicationController

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
end