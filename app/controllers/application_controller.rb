class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include StaticPagesHelper
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :set_locale_and_redirect

  private

  # Redirect all traffic to apex domain with a translation path
  def redirect_to_path(path)
    url = Rails.env.production? ? "https://simonsomlai.com" : request.protocol + request.host_with_port
    redirect_to "#{url}#{path.chomp("/")}", :status => :moved_permanently 
  end

  def is_old?
    request.host == 'truetech.be' || request.subdomain == "www"
  end

  def set_locale_and_redirect
    if params[:locale].present?
      I18n.locale = params[:locale].split("?")[0]
      redirect_to_path(request.path) if is_old?
    else
      I18n.locale = I18n.default_locale
      redirect_to_path "/#{I18n.locale}#{request.path}"
    end
  end

  def default_url_options(options = {})
  	{locale: I18n.locale}
  end
end


