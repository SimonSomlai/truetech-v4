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

  def homepage_sql_caching # Cache frequent queries to improve speed
    @projects ||= Rails.cache.fetch('homepage_project_queries', expires_in: 10.minutes) do
      Project.includes(:project_images).limit(6).order('created_at DESC')
    end
    @testimonials ||= Rails.cache.fetch("homepage_testimonial_queries", :expires_in => 10.minutes) do
      Testimonial.all.order('created_at DESC')
    end
    # Seperate normal articles from technical articles (latter only shows on en locale)
    @nl_articles ||= Rails.cache.fetch('homepage_nl_article_queries', expires_in: 10.minutes) do
      Article.where.not(category: 'Coding').where(posted: true).limit(5).order('created_at DESC')
    end
    @en_articles ||= Rails.cache.fetch('homepage_en_article_queries', expires_in: 10.minutes) do
      Article.where(posted: true).limit(5).order('created_at DESC')
    end
  end
end
