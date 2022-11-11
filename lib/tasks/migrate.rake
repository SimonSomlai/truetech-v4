require 'open-uri'

desc "Migrates article images"
task :mai => :environment do
  Rails.logger = Logger.new(STDOUT)
  # Articles
  Article.find_each do |article|
    begin
      filename = File.basename(URI.parse(article.image.url).to_s)
      puts filename, article.image.url
      file = URI.open(article.image.url)
      article.image_new.attach(io: file, filename: filename )
    rescue => e
      puts e
      ## log/handle your errors in order to retry later
    end
  end

  # Projects
  Project.find_each do |project|
    begin
      urls = project.project_images.map(&:images).map(&:url)
      urls.each do |url|
        filename = File.basename(URI.parse(url).to_s)
        puts filename, url
        file = URI.open(url)
        project.project_images_new.attach(io: file, filename: filename)
      end
    rescue => e
      puts e
      ## log/handle your errors in order to retry later
    end
  end
  
  # a.project_images_new.map {|i| ActiveStorage::Blob.service.url(i.key, disposition: 'inline', content_type: i.content_type, filename: i.filename, expires_in: 200_000)}
end



 
