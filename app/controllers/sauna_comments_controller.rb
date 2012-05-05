class SaunaCommentsController < ApplicationController
	include SimpleCaptcha::ControllerHelpers
	
	before_filter :correct_sauna, :only => :new

	def create
		if simple_captcha_valid?
			@sauna = Sauna.find(params[:sauna_comment][:sauna_id])
			@sauna_comment = @sauna.sauna_comments.build(params[:sauna_comment])
			if @sauna_comment.save
				flash[:success] = :sauna_comment_created
				respond_to do |format|
					format.html { redirect_to @sauna }
					format.js
				end
			else     
				render 'new'
			end		
		else
			render 'new'		
		end
	end
end