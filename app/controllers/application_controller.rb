class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include StaticPagesHelper
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :set_locale

  private

  def set_locale
  	I18n.locale = params[:locale].split("?")[0] if params[:locale].present?
  end

  def default_url_options(options = {})
  	{locale: I18n.locale}
  end
end


