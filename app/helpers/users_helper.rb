module UsersHelper
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin, :name, :profile_picture)
  end

  def setup
    @users = User.all
    @action = "New"
    @user = User.find(params[:id])
  end
end
