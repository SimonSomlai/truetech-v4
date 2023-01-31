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
      tags = Project.all.map(&:features).map{|feature| feature.gsub(/[{}]/,'').split(',').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge).keys}
      @cloud =  tags.flatten.reduce({}) do |acc, tag|
        if tag.downcase.match(/vue|react|node|javascript|ruby|graphql|gatsby|redux|contentful|static|next|bash|shell|quasar|electron|native/)
          acc[tag] ||= 0
          acc[tag] += 1
        end
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
