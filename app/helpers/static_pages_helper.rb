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
    @projects = Project.includes(:project_images).take(6).sort_by(&:created_at)
    @testimonials = Testimonial.all.sort_by(&:created_at)
    @nl_articles = Article.where.not(title: "").where(posted: true).sort_by(&:created_at).take(5)
    @en_articles = Article.where(title: "").where(posted: true).sort_by(&:created_at).take(5)
  end
end
