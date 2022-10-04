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
      Project.includes(:project_images).take(6).sort_by(&:created_at)
    end
    @testimonials ||= Rails.cache.fetch("homepage_testimonial_queries", :expires_in => 10.minutes) do
      Testimonial.all.sort_by(&:created_at)
    end
    # Seperate normal articles from technical articles (latter only shows on en locale)
    @nl_articles ||= Rails.cache.fetch('homepage_nl_article_queries', expires_in: 10.minutes) do
      Article.where.not(category: 'Coding').where(posted: true).take(5).sort_by(&:created_at)
    end
    @en_articles ||= Rails.cache.fetch('homepage_en_article_queries', expires_in: 10.minutes) do
      Article.where(posted: true).take(5).sort_by(&:created_at)
    end
  end
end
