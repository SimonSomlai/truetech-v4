require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @simon = users(:simon)
    @article = articles(:one)
  end

  test "should redirect to home when creating, posting, editing, updating & deleting articles w/o login" do
    # Trying to see articles
    get :index
    assert_redirected_to login_path

    # Trying to create
    get :create
    assert_redirected_to login_path

    # Trying to edit
    get :edit, id: @article
    assert_redirected_to login_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @article, article: {
      title: @article.title
    }
    assert_redirected_to login_path
    assert_not flash.empty?

    # Trying to delete
    assert_no_difference "Article.count" do
      delete :destroy, id: @article.id
    end
    assert_redirected_to login_path
  end

  test "should be able to crud when logged in as admin" do
    log_in_as(@simon)
    current_user = @simon

    # Trying to create succesfully
    assert_difference "Article.count", 1 do
      post :create, article: {
        title: "Title",
        description: "MyText",
        body: "MyText",
        slug: "Title",
        category: "MyString",
        posted: false,
        user_id: @simon
      }
    end
    
    # Trying to patch succesfully
    patch :update, id: @article, article: {
      title: "Title",
      description: "MyString"
    }
    assert_redirected_to articles_path
    assert_not flash.empty?

    # Trying to delete successfully
    assert_difference "Article.count", -1 do
      delete :destroy, id: @article.id
    end
    assert_redirected_to articles_path
  end
end
