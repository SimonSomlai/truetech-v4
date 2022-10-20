desc "Migrates article images"
task :mai => :environment do
  Rails.logger = Logger.new(STDOUT)
  Article.find_each do |article|
    begin
      filename = File.basename(URI.parse(article.image.url).to_s)
      article.image_new.attach(io: open(article.image.url), filename: filename )
      puts filename, article.image.url
    rescue => e
      puts e
      ## log/handle your errors in order to retry later
    end
  end
end


 
