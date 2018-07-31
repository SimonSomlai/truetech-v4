module SessionsHelper
  # ----------------------- STANDARD LOGIN ----------------------------------------------
  # Create an encrypted cookie in the browser of the users' id that corresponds to
  # the matching user using password & email combination in the login form
  def login(user)
    session[:user_id] = user.id
    current_user
  end

  # Delete browser session for user_id and set current_user variable to nil
  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    # If there's a session called user_id in the browser, set it to user_id
    if (user_id = session[:user_id])
      # See if there's a current user (object) variable matching a user_id session in the browser. If there is one, keep it.
      # else, set the variable to that session.
      @current_user ||= User.find_by(id: user_id)
    end
  end

  # Check if the current_user variable has been made.
  def logged_in?
    !current_user.nil?
  end

  # Is this a logged in user?
  def logged_in_user?
    unless logged_in?
      redirect_to new_user_session_path
      flash[:danger] = "Please login to do that action"
    end
  end

  # Function that checks if the current logged in user is an admin -> returns boolean
  def is_admin
    current_user.admin?
  end

  # before_action for authorization in controller
  def is_admin?
    if !is_admin
      flash[:danger] = "Only admins can do that"
      redirect_to home_path
    end
  end
end
