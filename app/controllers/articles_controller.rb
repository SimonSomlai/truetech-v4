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
    if params[:article] # If user switches locale on article show
      # If locale passed in is en (so he wants to switch to en), the slug_en is also passed in..
      @article = I18n.locale == :en ? Article.find_by(slug_en: params[:article]) : Article.find_by(slug_nl: params[:article])
      redirect_to articles_show_path(@article)
    else # Just for normal clicks on the homepage
      @article = Article.friendly.find(params[:id])
    end
    @relatedarticles = Article.where(category: @article.category).uniq.limit(6).where.not(id: @article)
  end

  def create
    @articles = Article.all
    @article = Article.new(article_params)
    @article.update_attribute(:user_id, current_user.id)
    if @article.save
      flash[:success] = @article.posted? ? "Article succesfully posted!" : "Draft succesfully saved!"
      redirect_to articles_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def edit
    @action = "Edit"
    render :index
  end

  def update
    @action = "Edit"
    if @article.update(article_params)
      flash[:success] = "Article succesfully updated!"
    else
      flash[:danger] = "Something went wrong!"
    end
    render :index
  end

  def destroy
    if @article.destroy
      flash[:success] = "Article succesfully deleted!"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to articles_path
  end
end
