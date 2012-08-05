class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_command_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to new_command_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end
  
  def tagged_with
    @bookmark = {}
    @bookmark[:results] = Bookmark.tagged_with(params[:query]).where(:user_id => current_user.id)
    @bookmark[:tag] = params[:query]
  end
end
