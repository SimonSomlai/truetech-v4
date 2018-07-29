class SessionsController < ApplicationController
  def new

  end

  def create
    # When session form is send to sessions#create, find the email of the user in the nested hash.
    user = User.find_by(email: params[:session][:email].downcase)
    # If the email matches one in the db and the password matches
    if user && user.authenticate(params[:session][:password])
      login user
      user.admin ? (redirect_to admin_path) : (redirect_to forum_path)
      flash[:success] = "Welcome back #{user.name}!"
    else
      flash.now[:danger] = "Incorrect email or password"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to home_path
    flash[:success] = "See you soon!"
  end
end
