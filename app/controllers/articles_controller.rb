class ArticlesController < ApplicationController
  # ======================================================
  # Filters & Imports
  # ======================================================
  include ArticlesHelper
  before_action :setup, only: [:edit, :update, :destroy]
  before_action :logged_in_user?, except: [:show, :all_articles]
  before_action :is_admin?, except: [:show, :all_articles]

  # ======================================================
  # CRUD
  # ======================================================
  def index
    @action = "New"
    @articles = Article.all.sort_by(&:created_at).reverse
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
    @relatedarticles = Article.where(category: @article.category, posted: true).where.not(id: @article).uniq.take(6)
  end

  def create
    @articles = Article.all.sort_by(&:created_at).reverse
    @article = Article.new(article_params)
    @article.update_attribute(:user_id, current_user.id)
    if @article.save
      flash[:success] = @article.posted? ? "Article succesfully posted!" : "Draft succesfully saved!"
      redirect_to articles_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
    system "rake jobs:workoff"
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
    system "rake jobs:workoff"
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

  # ======================================================
  # Other
  # ======================================================
  def all_articles
    @nl_articles = Article.where.not(title: "").where(posted: true).sort_by(&:created_at).reverse
    @en_articles = Article.where(title: "").where(posted: true).sort_by(&:created_at).reverse
    @en_categories = Article.all.map(&:category).uniq!
    @nl_categories = @en_categories.reject{|i| /coding/i.match(i)}
    I18n.locale == :nl ? (@articles = @nl_articles) : (@articles = @en_articles)
  end
end
