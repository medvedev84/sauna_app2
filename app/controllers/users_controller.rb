class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :show, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:index, :show, :edit, :update]
#  before_filter :admin_user, :only => [:new, :destroy]
  
  def show
    @user = User.find(params[:id])
    @saunas = @user.saunas
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = :user_created
      redirect_to users_path
    else
      render 'new'
    end
  end

  def index 
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = :profile_updated 
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = :user_destroyed
    redirect_to users_path
  end

  private

    def correct_user     
      if !current_user.admin? 
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end
    end
end