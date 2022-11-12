# Simon Somlai

> Last version of my company website.

# Tech Stack

- <b>Front:</b> HTML, CSS, JS
- <b>JS Libraries:</b> lightgallery, lazyload, zoom, tags, trumbowyg, rangeslider & chart.js
- <b>Back:</b> Ruby & RoR
- <b>Gems:</b> fog-aws, carrierwave, rest-client, oauth2, dalli, friendly_id, mailform, unicorn & sitemap_generator
- <b>Db:</b> Postgresql

## Database

<img src="models.png">

# Pics

## HomePage

<img src="home.png">

## Backend

<img src="back.png">

# To Do

- Write some generic smoke tests (visit all pages)
- Move & migrate to active storage: articles, projects, testimonials
  <!-- https://stackoverflow.com/questions/52528623/migrating-carrierwave-to-activestorage -->
  <!-- ActiveStorage::Attachment -->
- Add free images uploader for embedding in articles
- Finish/swap trix editor (fullscreen, html edit, divider, styling)
- Add linters/tests before pushing
- Delete old junk (reduce bundle size)
- Rails 7 + read docs

Made with &lt;3 by <a target="_blank" href="https://simonsomlai.com/en"> Simon Somlai</a>

require 'open-uri'

# desc "Migrates article images"

# task :mai => :environment do

# Rails.logger = Logger.new(STDOUT)

# # Articles

# Article.find_each do |article|

# begin

# filename = File.basename(URI.parse(article.image.url).to_s)

# puts filename, article.image.url

# file = URI.open(article.image.url)

# article.image_new.attach(io: file, filename: filename )

# rescue => e

# puts e

# ## log/handle your errors in order to retry later

# end

# end

# # Projects

# Project.find_each do |project|

# begin

# urls = project.project_images.map(&:images).map(&:url)

# urls.each do |url|

# filename = File.basename(URI.parse(url).to_s)

# puts filename, url

# file = URI.open(url)

# project.project_images_new.attach(io: file, filename: filename)

# end

# rescue => e

# puts e

# ## log/handle your errors in order to retry later

# end

# end

# # a.project_images.map {|i| ActiveStorage::Blob.service.url(i.key, disposition: 'inline', content_type: i.content_type, filename: i.filename, expires_in: 200_000)}

# end
