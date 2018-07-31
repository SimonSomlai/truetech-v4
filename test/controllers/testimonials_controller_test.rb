require 'test_helper'

class TestimonialsControllerTest < ActionController::TestCase
  def setup
    @simon = users(:simon)
    @testimonial = testimonials(:one)
  end

  test "should redirect to home when creating, posting, editing, updating & deleting testimonials w/o login" do
    # Trying to see testimonials
    get :index
    assert_redirected_to new_user_session_path

    # Trying to create
    get :create
    assert_redirected_to new_user_session_path

    # Trying to edit
    get :edit, id: @testimonial
    assert_redirected_to new_user_session_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @testimonial, testimonial: {
      title: @testimonial.name
    }
    assert_redirected_to new_user_session_path
    assert_not flash.empty?

    # Trying to delete
    assert_no_difference "Testimonial.count" do
      delete :destroy, id: @testimonial.id
    end
    assert_redirected_to new_user_session_path
  end

  test "should be able to crud when logged in as admin" do
    log_in_as(@simon)

    # Trying to create succesfully
    assert_difference "Testimonial.count", 1 do
      post :create, testimonial: {
        name: "MyString",
        company: "MyString",
        quote: "MyText"
      }
    end

    # Trying to edit succesfully
    get :edit, id: @testimonial
    assert_template "testimonials/index"

    # Trying to patch succesfully
    patch :update, id: @testimonial, testimonial: {
      name: "MyString",
      company: "MyString",
      quote: "MyText"
    }

    assert_redirected_to testimonials_path
    assert_not flash.empty?

    # Trying to delete successfully
    assert_difference "Testimonial.count", -1 do
      delete :destroy, id: @testimonial.id
    end
    assert_redirected_to testimonials_path
  end
end
