require "oauth2"
require 'google/apis/analytics_v3'
require 'google/apis/webmasters_v3'
require "json"
require "rest-client"

module StaticPagesHelper

  def active?(page) # Adds current_page class to admin menu
    'current_page' if current_page?("/#{page}")
  end

  def table_hidden? # Displays/hides table on index page based on action
    'col-hidden' if @action == 'Edit'
  end

  def form_hidden? # Displays/hides form on index page based on action
    'col-hidden' if @action != 'Edit'
  end

  def is_personal? # returns true if website accessed is simonsomlai.com
    !!request.env["SERVER_NAME"].match(/simonsomlai/)
  end

  def homepage_sql_caching # Cache frequent queries to improve speed
    @projects ||= Rails.cache.fetch('homepage_project_queries', expires_in: 10.minutes) do
      Project.includes(:project_images).limit(6).order('created_at DESC')
    end
    @testimonials ||= Rails.cache.fetch("homepage_testimonial_queries", :expires_in => 10.minutes) do
      Testimonial.all.order('created_at DESC')
    end
    # Seperate normal articles from technical articles (latter only shows on en locale)
    @nl_articles ||= Rails.cache.fetch('homepage_nl_article_queries', expires_in: 10.minutes) do
      Article.where.not(category: 'Coding').where(posted: true).limit(6).order('created_at DESC')
    end
    @en_articles ||= Rails.cache.fetch('homepage_en_article_queries', expires_in: 10.minutes) do
      Article.where(posted: true).limit(6).order('created_at DESC')
    end
  end

  # ------------------------------- GOOGLE ANALYTICS + TOKENS --------------------------------

  def authorize_google_analytics # Authorize GA based on access & refresh token
    access_token = Setting.find_by(key: "analytics_access_token")
    refresh_token = Setting.find_by(key: "analytics_refresh_token")

    authorization = Signet::OAuth2::Client.new({
      access_token: access_token.value,
      refresh_token: refresh_token.value,
      client_id: ENV["ANALYTICS_CLIENT_ID"],
      client_secret: ENV["ANALYTICS_CLIENT_SECRET"]
    })

    authorization.expires_in = Time.now + 1_000_000
    service = Google::Apis::AnalyticsV3::AnalyticsService.new
    service.authorization = authorization
    service
  end

  def set_new_tokens # Generates link to request new access code
    client = OAuth2::Client.new(ENV["ANALYTICS_CLIENT_ID"], ENV["ANALYTICS_CLIENT_SECRET"], {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'})

    link = client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://truetech.be/callback',
      approval_prompt: "force",
      :access_type => 'offline' })

    redirect_to link
  end

  def refresh_access_token(refresh_token) # Request new access_token if current is dated
    data = {
      :client_id => ENV["ANALYTICS_CLIENT_ID"],
      :client_secret => ENV["ANALYTICS_CLIENT_SECRET"],
      :refresh_token => refresh_token,
      :grant_type => "refresh_token"
    }

    @response = ActiveSupport::JSON.decode(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
    access_token = @response["access_token"]

    update_tokens(access_token,refresh_token)
  end

  def update_tokens(access_token, refresh_token) # Update refresh & access_token in database
    @access_token = Setting.where(key: "analytics_access_token").first_or_create(key: "analytics_access_token", value: access_token)
    @access_token.update_attribute("value",access_token)
    @refresh_token = Setting.where(key: "analytics_refresh_token").first_or_create(key: "analytics_refresh_token", value: refresh_token)
    @refresh_token.update_attribute("value",refresh_token)
  end

  # Sets @today, @top_content_today, @weekly_referrers, @top_content_this_week & @year_array for admin dashboard
  def get_statistics(service)
    day = Time.zone.now

    response = service.get_ga_data("ga:141996448",day.strftime("%Y-%m-%d"),day.strftime("%Y-%m-%d"),'ga:users,ga:pageviews', {
      dimensions: "ga:fullReferrer,ga:pagePath", sort: "-ga:pageviews"
    })

    visitors = response.totals_for_all_results["ga:users"]
    pageviews = response.totals_for_all_results["ga:pageviews"]

    if response.rows # If there are visitors/pageviews today
      referrers = response.rows.collect{|r| {referrer: r[0], landing: r[1], visitors: r[2], pageviews: r[3]}}
      top_content = referrers.collect{|a| {page: a[:landing], pageviews: a[:pageviews]}}
    else # Set everything to blank/0
      referrers, top_content = [{referrer: "", landing: "", visitors: "0", pageviews: "0"}], [{page: "", pageviews: "0"}]
    end

    # Create or update the Visit for today
    @visit = Visit.where(date: day).first_or_create(visitors: visitors, pageviews: pageviews, referrers: referrers, top_content: top_content, date: day.strftime("%Y-%m-%d"))
    @visit.update_attributes(visitors: visitors, pageviews: pageviews, referrers: referrers, top_content: top_content, date: day)

    # Get all Visit objects from the last 12 months, oldest to new
    # @this_year ||= Rails.cache.fetch('visits_this_year', expires_in: 1.years) do
      @this_year ||= Visit.all.order("date ASC").limit(360)
    # end
    @this_week = @this_year.reverse[0..6].reverse # Get all Visit objects from the last 7 days
    @today = @visit # Get the Visit object for today

    # TOTAL VISITS & PAGEVIEWS
    # This Week
    @week_array = @this_week.collect{|visit| [visit.pageviews,visit.visitors] }
    # This Year
    @year_array = []
    @this_year.each_slice(30) do |array| # Creates a nested array of pageviews & visitors based on slices of 30 days (1 month)
      @year_array << array.collect{|visit| [visit.pageviews,visit.visitors] }.transpose.map {|array| array.reduce(:+)}
    end # => [[30,8],[65,22],[35,15],[112,50],...]

    # TOP REFERRERS
    # This Week
    @weekly_referrers = @this_week.collect(&:referrers).flatten.group_by{ |hash| hash.values_at(:referrer, :landing) }
    referrer_array = []
    @weekly_referrers.each do |array| # Same thing as year_array, only for this week
      referrer_array << (array[0] + @weekly_referrers[array[0]].collect{|hash| [hash[:visitors].to_i, hash[:pageviews].to_i]}.transpose.map {|array| array.reduce(:+)})
    end # => [[30,8],[65,22],[35,15],[112,50],...]
    @weekly_referrers = referrer_array.sort_by{|array| -array[2]}[0..20]

    # TOP CONTENT
    # Today
    @top_content_today = @today.top_content.sort_by{|k,v| -k[:pageviews]}.reverse # Get the top_content from today
    # This Week
    @top_content = @this_week.collect(&:referrers).flatten.group_by{ |hash| hash.values_at(:landing) }
    top_content_array = []
    @top_content.each do |array|
      top_content_array << (array[0] + @top_content[array[0]].collect{|hash| [hash[:visitors].to_i, hash[:pageviews].to_i]}.transpose.map {|array| array.reduce(:+)})
    end
    @top_content_this_week = top_content_array.sort_by{|array| -array[2]}[0..15] # Get the top 10 pages this week
  end
end
