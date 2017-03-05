module ArticlesHelper
  def article_params
    params.require(:article).permit(:title, :description, :body, :image, :user_id, :category, :posted, :slug_nl, :slug_en, :en_description, :en_body, :en_title)
  end

  # Cleaning up the controller
  def setup
    @article = Article.friendly.find(params[:id])
  end

  # Find the author by project.user_id
  def author(article)
  	return User.find_by(id: "#{article.user_id}").name
  end

  def meta_title
    I18n.locale == :nl ? "#{@article.title}" : "#{@article.en_title}"
  end

  def meta_description
    I18n.locale == :nl ? "#{@article.description}" : "#{@article.en_description}"
  end
end
