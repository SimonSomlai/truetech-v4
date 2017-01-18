class ArticlesController < ApplicationController
  include ArticlesHelper
  before_action :setup, only: [:edit, :update, :destroy]
  before_filter :logged_in_user?, except: [:show]
  before_filter :is_admin?, except: [:show]

  def index
    @action = "New"
    @articles = Article.all
    @article  = Article.new
  end

  def show
    if params[:article] # Switching between locales on show page
      if I18n.locale == :en # If locale passed in is en, the slug_en is also passed in..
        @article = Article.find_by(slug_en: params[:article])
      else  # If locale passed in is nl, find article by slug_nl ..
        @article = Article.find_by(slug_nl: params[:article])
      end
      redirect_to articles_show_path(@article)
    else # Just for normal clicks on the homepage
      @article = Article.friendly.find(params[:id])
    end
    @relatedarticles = Article.where(category: @article.category).uniq.limit(6).where.not(id: @article)
    ahoy.track "Article Views", title: "#{@article.title}" unless its_simon?
  end

  def create
    @articles = Article.all
    @article = Article.new(article_params)
    @article.update_attribute(:user_id, current_user.id)
    set_slugs_for_article # Sets slug_en & slug_nl for article
    if @article.save
      if @article.posted?
        flash[:success] = "Article succesfully posted!"
        redirect_to articles_path
      else
        flash[:success] = "Draft succesfully saved!"
        redirect_to articles_path
      end
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def edit
    @articles = Article.all
    @action = "Edit"
    render :index
  end

  def update
    @action = "Edit"
    @articles = Article.all
    # Add new, updated slugs to article_params
    updated_article_params = update_slugs_for_article(article_params)
    if @article.update(updated_article_params)
      flash[:success] = "Article succesfully updated!"
      render :index
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_path
      flash[:success] = "Article succesfully deleted!"
    else
      flash[:danger] = "Something went wrong"
      redirect_to articles_path
    end
  end
end
