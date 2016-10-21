require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def setup
    @simon = users(:simon)
    @project= projects(:project1)
  end

  test "should redirect to home when creating, posting, editing, updating & deleting projects w/o login" do
    # Trying to see projects
    get :index
    assert_redirected_to login_path

    # Trying to create
    get :create
    assert_redirected_to login_path

    # Trying to edit
    get :edit, id: @project
    assert_redirected_to login_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @project, project: {
      title: @project.title
    }
    assert_redirected_to login_path
    assert_not flash.empty?

    # Trying to delete
    assert_no_difference "Project.count" do
      delete :destroy, id: @project.id
    end
    assert_redirected_to login_path
  end

  test "should be able to crud when logged in as admin" do
    log_in_as(@simon)

    # Trying to create succesfully
    assert_difference "Project.count", 1 do
      post :create, project: {
        title: "Title",
        description: "MyString",
        features: "MyText",
        link: "MyString",
        service: "MyString",
        skills: "MyStrin",
        user_id: @simon.id
      }
    end

    # Trying to edit succesfully
    get :edit, id: @project
    assert_template "projects/index"

    # Trying to patch succesfully
    patch :update, id: @project, project: {
        title: "Title",
        description: "MyString",
        features: "MyText",
        link: "MyString"
    }
    assert_redirected_to projects_path
    assert_not flash.empty?

    # Trying to delete successfully
    assert_difference "Project.count", -1 do
      delete :destroy, id: @project.id
    end
    assert_redirected_to projects_path
  end
end
