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
highlight.min.js
 )
