class PagesController < ApplicationController
  include PagesHelper
  before_action :setup, except: [:index, :create]
  before_filter :logged_in_user?, except: [:show]
  before_filter :is_admin?, except: [:show]

  def index
    @pages = Page.all
    @action = "New"
    @page = Page.new

  end

  def create
    @page = Page.new(pages_params)
    if @page.save
      p "Page was a success!"
      redirect_to pages_path
    else
      p "something went wrong"
      render :index
    end
  end

  def show
    @contact = Contactform.new
  end

  def edit
    @action = "Edit"
    render :index
  end

  def update
    @action = "Edit"
    if @page.update(pages_params)
      flash[:success] = "Page succesfully updated!"
      render :index
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def destroy
    if @page.destroy
      redirect_to pages_path
      flash[:success] = "Page succesfully deleted!"
    else
      flash[:danger] = "Something went wrong"
      redirect_to pages_path
    end
  end
end