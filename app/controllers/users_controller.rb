class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  require 'will_paginate'

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    if signed_in?
      redirect_to(root_path)
      return
    end
    @user = User.new
    @title = "Sign up"
  end

  def create
    if signed_in?
      redirect_to(root_path)
      return
    end
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome!" }
    else
      @title = "Sign up"
      @user.password.replace ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }    
    else
      @title = "Edit user"
      render 'edit'
    end    
  end

  def destroy
#    User.find(params[:id]).destroy
#    flash[:success] = "User deleted."
#    redirect_to users_path
    @user.destroy
    redirect_to users_path, :flash => { :success => "User deleted." }
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)  

  end

end
