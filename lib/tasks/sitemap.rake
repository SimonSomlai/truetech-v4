require "time"

task :generate_sitemap do
  if Time.now.tuesday?
     Rake::Task["sitemap:refresh"].invoke
   end
end
