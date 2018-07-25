class PagesController < ApplicationController
  include PagesHelper
  before_action :setup, except: [:index, :create]
  before_action :logged_in_user?, except: [:show]
  before_action :is_admin?, except: [:show]

  def index
    @pages = Page.all
    @action = "New"
    @page = Page.new
  end

  def create
    @page = Page.new(pages_params)
    if @page.save
      flash[:success] = "Page was created succesfully!"
      redirect_to pages_path
    else
      flash[:danger] = "something went wrong"
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
    else
      flash[:danger] = "Something went wrong!"
    end
    render :index
  end

  def destroy
    if @page.destroy
      flash[:success] = "Page succesfully deleted!"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to pages_path
  end
end
