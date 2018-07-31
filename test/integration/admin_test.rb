require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  def setup
    @simon = users(:simon)
  end

  test "should display admin & logout links correctly" do
    get home_path
    assert_select "a[href=?]", admin_path, count: 0
    assert_select "a[href=?]", destroy_user_session_path, count: 0

    log_in_as(@simon)
    get home_path
    assert_select "a[href=?]", admin_path, count: 1
    assert_select "a[href=?]", destroy_user_session_path, count: 1
  end
end
