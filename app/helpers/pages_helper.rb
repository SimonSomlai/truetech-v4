module PagesHelper
  def setup
    @pages = Page.all
    @page = Page.friendly.find(params[:id])
  end

  def pages_params
    params.require(:page).permit(:title, :description, :body, :slug)
  end
end
