class UsersController < ApplicationController
  include UsersHelper
  before_action :setup, only: [:edit, :update, :destroy]
  before_action :logged_in_user?, except: [:new_forum_member, :create_forum_member], if: -> { User.any? } # Only allow user actions for users
  before_action :is_admin?, except: [:new_forum_member, :create_forum_member], if: -> { User.any? } # Only allow user actions for users who are admins

  # ======================================================
  # REGULAR USERS
  # ======================================================
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

  # ======================================================
  # CREATING FORUM MEMBERS
  # ======================================================
  def new_forum_member
    @user = User.new
    render :new_forum_member
  end

  def create_forum_member
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User succesfully created!"
      login @user
      redirect_to forum_path
    else
      flash[:danger] = "Something went wrong!"
      render :new_forum_member
    end
  end
end
