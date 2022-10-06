module ArticlesHelper
  def setup # General variable assigment
    @articles = Article.all.sort_by(&:created_at).reverse
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :image, :user_id, :category, :posted, :slug_nl, :slug_en, :en_description, :en_body, :en_title, :content, :en_content)
  end

  def author(article) # Find the author by article.user_id
  	User.find_by(id: "#{article.user_id}").name
  end

  def meta_title # Sets meta title according to locale
    I18n.locale == :nl ? "#{@article.title}" : "#{@article.en_title}"
  end

  def meta_description # Sets meta description according to locale
    I18n.locale == :nl ? "#{@article.description}" : "#{@article.en_description}"
  end

  def categories
    Article.all.map(&:category).uniq.map(&:capitalize)
  end
end
