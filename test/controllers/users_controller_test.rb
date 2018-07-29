require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @simon = users(:simon)
  end

  test "should redirect to home when creating, posting, editing, updating & deleting users w/o login" do
    # Trying to see users
    get :index
    assert_redirected_to new_user_session_path

    # Trying to create
    get :create
    assert_redirected_to new_user_session_path

    # Trying to edit
    get :edit, id: @simon
    assert_redirected_to new_user_session_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @simon, user: {
      name: @simon.name,
      email: @simon.email,
      admin: true
    }
    assert_redirected_to new_user_session_path
    assert_not flash.empty?

    # Trying to delete
    assert_no_difference "User.count" do
      delete :destroy, id: @simon
    end
    assert_redirected_to new_user_session_path
  end

  test "should be able to crud when logged in as admin" do
    log_in_as(@simon)

    # Trying to create succesfully
    assert_difference "User.count", 1 do
      post :create, user: {
        name: "Example User",
        email: "user@validformat.com",
        password: "password",
        password_confirmation: "password"
      }
    end

    # Trying to edit succesfully
    get :edit, id: @simon
    assert_template "users/index"

    # Trying to patch succesfully
    patch :update, id: @simon, user: {
      name: @simon.name,
      email: @simon.email,
      password: "password",
      password_confirmation: "password",
      admin: false
    }
    assert_redirected_to users_path
    assert_not flash.empty?

    # Trying to delete successfully
    assert_difference "User.count", -1 do
      delete :destroy, id: @simon.id
    end
    assert User.find_by(id: @simon).nil?
    assert_redirected_to users_path
  end
end
