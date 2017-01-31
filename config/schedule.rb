# config/schedule.rb
every 1.week do
  rake "sitemap:refresh"
end
