# config/schedule.rb
every 1.minute do
  rake "sitemap:refresh"
end
