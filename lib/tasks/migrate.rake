require 'open-uri'

desc "Migrates article images"
task :mai => :environment do
  Rails.logger = Logger.new(STDOUT)
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
end


 
