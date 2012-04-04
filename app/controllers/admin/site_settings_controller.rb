class Admin::SiteSettingsController < AdminController
	before_filter :authenticate 
	before_filter :super_admin_user

	def index 
		redirect_to "/admin/site_settings/1/edit"
	end

	def edit
		@site_setting = SiteSetting.find(1)
	end

	def update
		@site_setting = SiteSetting.find(1)
		if @site_setting.update_attributes(params[:site_setting])	
			flash[:success] = :settings_updated 
			redirect_to admin_users_path
		else
			render 'edit'
		end
	end

end