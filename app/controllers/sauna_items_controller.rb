class SaunaItemsController < ApplicationController
  before_filter :authenticate, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :owner_user, :only => [:new, :edit, :update, :destroy]
  before_filter :correct_sauna, :only => :new

  def new                             
    @sauna = Sauna.find(params[:id])
    @sauna_item = SaunaItem.new
  end

  def create
    @sauna = Sauna.find(params[:sauna_item][:sauna_id])
    @sauna_item = @sauna.sauna_items.build(params[:sauna_item])
    if @sauna_item.save
      flash[:success] = :sauna_item_created
      redirect_to @sauna_item
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
  end

  def update
    @sauna_item = SaunaItem.find(params[:id])
    if @sauna_item.update_attributes(params[:sauna_item])
      flash[:success] = :sauna_item_updated
      redirect_to @sauna_item
    else
      render 'edit'
    end
  end

  def destroy
    SaunaItem.find(params[:id]).destroy
    flash[:success] = "Sauna item destroyed."
  end


  private
  
    def correct_sauna
      @sauna = Sauna.find(params[:id])
      @user = User.find(@sauna.user_id)
      redirect_to(root_path) unless current_user?(@user)
    end

    def owner_user
      redirect_to(root_path) unless current_user.owner?
    end

    def correct_user
      @sauna_item = SaunaItem.find(params[:id])
      @sauna = Sauna.find(@sauna_item.sauna_id)
      @user = User.find(@sauna.user_id)
      redirect_to(root_path) unless current_user?(@user)
    end


end