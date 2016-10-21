class UsersController < ApplicationController
  include UsersHelper
  before_action :setup, only: [:edit, :update, :destroy]
  before_filter :logged_in_user?, if: "User.any?"
  before_filter :is_admin?, if: "User.any?"


  def index
    @action = "New"
    @users = User.all
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User succesfully created!"
      login @user
      redirect_to admin_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def edit
    @action = "Edit"
    render :index
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User succesfully updated!"
      redirect_to users_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User succesfully deleted!"
      redirect_to users_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

end
