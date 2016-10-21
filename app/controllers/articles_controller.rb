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
    if params[:article]
      if I18n.locale == :en
        @article = Article.find_by(slug_en: params[:article])
        redirect_to articles_show_path(@article)
      else
        @article = Article.find_by(slug_nl: params[:article])
        redirect_to articles_show_path(@article)
      end
    else
      @article = Article.friendly.find(params[:id])
    end
    @relatedarticles = Article.where(category: @article.category).uniq.limit(6).where.not(id: @article)
    ahoy.track "Article Views", title: "#{@article.title}" unless its_simon?
  end

  def create
    @articles = Article.all
    @article = Article.new(article_params)
    if @article.save
      if I18n.locale == :en
        @article.set_friendly_id(article_params[:title], :nl)
      elsif I18n.locale == :nl
        @article.set_friendly_id(article_params[:en_title], :en)
      end
      @article.update_attribute(:user_id, current_user.id)
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
    if @article.update(article_params)
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
