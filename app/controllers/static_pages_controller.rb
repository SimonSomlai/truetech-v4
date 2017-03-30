class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_filter :logged_in_user?, only: [:admin], if: "User.any?"
  before_filter :is_admin?, only: [:admin], if: "User.any?"
  before_action :homepage_sql_caching, only: [:home]
  before_action :setup

  def home
  end

  def single_page
  end

  def starters_website
  end

  def website_op_maat
  end

  def webapplicatie
  end

  def admin
    cookies['truetech_admin_cookie'] ||= {
      :value => true,
      :expires => 10.years.from_now
    }
    @refresh_token = Setting.find_by(key: "analytics_refresh_token")

    if @refresh_token # If there is a refresh token
      refresh_access_token(@refresh_token.value) # Use it to renew the access token
      @refresh_token = Setting.find_by(key: "analytics_refresh_token") # Get it
      service = authorize_google_analytics # Authorize GA
      get_statistics(service) # Query it for dashboard
      render "admin"
    else
      set_new_tokens # Set it
    end
  end

  def callback # Handle omniauth callback by parsing code & requesting tokens (access & refresh)
    client = OAuth2::Client.new(ENV["ANALYTICS_CLIENT_ID"], ENV["ANALYTICS_CLIENT_SECRET"], {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'}
    )
    code = params[:code]

    response = client.auth_code.get_token(code, :redirect_uri => 'http://truetech.be/callback')
    access_token = response.token
    refresh_token = response.refresh_token

    update_tokens(access_token, refresh_token)

    redirect_to "/admin"
  end

  def website_analyse

  end

  def setup
    @contact = Contactform.new
  end
end
