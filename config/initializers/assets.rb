Rails.application.config.assets.precompile += %w( .svg .eot .woff .woff2 .ttf )
Rails.application.config.assets.compress = true

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# CSS files
Rails.application.config.assets.precompile += %w(
reset.css
admin.css
agency.css
agency-style.css
animate.css
flatsome.min.css
font-icons.css
jquery.tagsinput.css
magnific-popup.css
range-sliders.css
responsive.css
style.css
trumbowyg.min.css
highlight.min.css )

# JS files
<<<<<<< HEAD
Rails.application.config.assets.precompile += %w( trumbowyg.min.js )
Rails.application.config.assets.precompile += %w( jquery.tagsinput.js )
Rails.application.config.assets.precompile += %w( rangeslider.min.js )
Rails.application.config.assets.precompile += %w( functions.js )
Rails.application.config.assets.precompile += %w( plugins.js )
Rails.application.config.assets.precompile += %w( Chart.min.js )
Rails.application.config.assets.precompile += %w( custom.js )
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.precompile += %w( jquery_ujs.js )
Rails.application.config.assets.precompile += %w( jquery.remotipart.js )
Rails.application.config.assets.precompile += %w( script.js )
Rails.application.config.assets.precompile += %w( ahoy.js )
=======
Rails.application.config.assets.precompile += %w( trumbowyg.min.js
jquery.tagsinput.js
rangeslider.min.js
functions.js
plugins.js
Chart.min.js
custom.js
jquery.js
jquery_ujs.js
jquery.remotipart.js
script.js
ahoy.js
highlight.min.js
 )
>>>>>>> technical_articles
