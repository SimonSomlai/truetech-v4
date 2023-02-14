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
    @projects = Project.includes(:project_images_attachments).sort_by(&:created_at).reverse.take(6)
    @testimonials = Testimonial.all.sort_by(&:created_at).reverse
    @nl_articles = Article.where.not(title: "").where(posted: true).sort_by(&:created_at).reverse.take(5)
    @en_articles = Article.where(title: "").where(posted: true).sort_by(&:created_at).reverse.take(5)
    begin 
      tags = Project.all.map{|project| project.tags.map(&:name)}
      @cloud = tags.flatten.reduce({}) do |acc, tag|
        formatted_name = tag.humanize.downcase
        acc[formatted_name] ||= 0
        acc[formatted_name] += 1
        acc
      end
      @cloud = @cloud.sort_by {|k,v| v}.reverse.to_h
      @max = @cloud.max_by{|k,v| v}[1]
    rescue
      @cloud = [] 
      @max = nil
    ensure
    end
  end
end
