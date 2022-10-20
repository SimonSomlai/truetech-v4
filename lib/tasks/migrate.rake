desc "Migrates article images"
task :mai => :environment do
  Rails.logger = Logger.new(STDOUT)
  Article.find_each do |article|
    begin
      filename = File.basename(URI.parse(article.image.url).to_s)
      puts filename, article.image.url
    rescue => e
      puts e
      ## log/handle your errors in order to retry later
    end
  end
end


 
