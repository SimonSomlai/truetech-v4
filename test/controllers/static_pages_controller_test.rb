require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @user = users(:simon)
  end

  test "should redirect on admin when not logged in" do
    # Get edit
    get :admin, id: @user
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
  end

  test "should succesfully get admin when logged in" do
    # Get edit
    log_in_as(@user)
    get :admin, id: @user
    assert_template "static_pages/admin"
  end
end
