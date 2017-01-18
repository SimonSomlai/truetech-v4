# frozen_string_literal: true
module StaticPagesHelper
  def active?(page)
    'current_page' if current_page?("/#{page}")
  end

  def table_hidden?
    'col-hidden' if @action == 'Edit'
  end

  def form_hidden?
    'col-hidden' if @action != 'Edit'
  end

  def get_referrals
    # Get the referrers from this week and push them to an array
    @weekly_referrers = Visit.where(started_at: time_range(0, 'weeks'), user_id: nil).map(&:referrer)
    @weekly_hash = Hash.new(0)
    # Count the duplicates and push them to a hash
    @weekly_referrers.each do |v|
      @weekly_hash[v] += 1
    end
    # Remove empty counts
    @weekly_hash = @weekly_hash.except!(nil).sort_by { |k, v| -v }[0..9]
    # Get the referrers from this day and push them to an array
    @daily_referrers = Visit.where(started_at: time_range(0, 'days'), user_id: nil).map(&:referrer)
    @daily_hash = Hash.new(0)
    # Count the duplicates and push them to a hash
    @daily_referrers.each do |v|
      @daily_hash[v] += 1
    end
    # Remove empty counts
    @daily_hash = @daily_hash.except!(nil).sort_by { |k, v| -v }[0..9]

    # Get the top 20 most used keywords to reach my site
    @keywords = Visit.where(user_id: nil).map(&:search_keyword)
    @keyword_hash = Hash.new(0)
    # Count the duplicates and push them to a hash
    @keywords.each do |v|
      @keyword_hash[v] += 1
    end
    # Remove empty counts, sort by highest value, only the first 20 results
    @keyword_hash = @keyword_hash.except!(nil).sort_by { |k, v| -v }[0..19]
  end

  def get_pageviews
    # Map all projects & articles by title
    @projects = Project.all.map(&:title)
    @articles = Article.all.map(&:title)
    @pages = ['Webapplicatie', 'Website Op Maat', 'Starters Website', 'Single Page', 'Homepage'] + @articles + @projects
    @events = Ahoy::Event.where(user_id: nil)
    @totalpageviews = {}
    @pageviews = {}
    # For each page on the website
    @pages.each do |page|
      # Get the daily pageviews
      @count = @events.select { |event| event[:properties]['title'] == page && time_range(0, 'days').cover?(event.time) }
      @count = @count.count
      # Push them to a 10-item hash based on highest views
      @pageviews[:"#{page}"] = @count
      @pageviews = Hash[@pageviews.sort_by { |k, v| -v }[0..9]]

      # Get the total pageviews
      @totalcount = @events.select { |event| event[:properties]['title'] == page }
      @totalcount = @totalcount.count
      # Push them to a 10-item hash based on highest views
      @totalpageviews[:"#{page}"] = @totalcount
      @totalpageviews = Hash[@totalpageviews.sort_by { |k, v| -v }[0..9]]
    end
  end

  def homepage_sql_caching
    @projects ||= Rails.cache.fetch('homepage_project_queries', expires_in: 10.minutes) do
      Project.includes(:project_images).limit(6).order('created_at DESC')
    end
    @testimonials ||= Rails.cache.fetch('homepage_testimonial_queries', expires_in: 10.minutes) do
      Testimonial.limit(5)
    end
    @testimonials ||= Rails.cache.fetch("homepage_testimonial_queries", :expires_in => 10.minutes) do
      Testimonial.limit(5)

    # Seperate normal articles from technical articles (latter only shows on en locale)
    @nl_articles ||= Rails.cache.fetch('homepage_nl_article_queries', expires_in: 10.minutes) do
      Article.where.not(category: 'Coding').where(posted: true).limit(6).order('created_at DESC')
    end
    @en_articles ||= Rails.cache.fetch('homepage_en_article_queries', expires_in: 10.minutes) do
      Article.where(posted: true).limit(6).order('created_at DESC')
    end
  end
end
