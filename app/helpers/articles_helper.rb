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

  def set_slugs_for_article # Set & Update slugs for articles
    @article.set_friendly_id(article_params[:title], :nl)
    @article.set_friendly_id(article_params[:en_title], :en)
  end

  def update_slugs_for_article(article_params) # Add updated slugs to params (not passed through form)
    article_params.merge! slug_nl: article_params[:title].gsub("\'", "").parameterize
    article_params.merge! slug_en: article_params[:en_title].gsub("\'", "").parameterize
    article_params
  end
end
