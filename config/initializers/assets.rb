Rails.application.config.assets.precompile += %w( .svg .eot .woff .woff2 .ttf )
Rails.application.config.assets.compress = true

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# CSS files
Rails.application.config.assets.precompile += %w( reset.css )
Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( agency.css )
Rails.application.config.assets.precompile += %w( agency-style.css )
Rails.application.config.assets.precompile += %w( animate.css )
Rails.application.config.assets.precompile += %w( flatsome.min.css )
Rails.application.config.assets.precompile += %w( font-icons.css )
Rails.application.config.assets.precompile += %w( jquery.tagsinput.css )
Rails.application.config.assets.precompile += %w( magnific-popup.css )
Rails.application.config.assets.precompile += %w( range-sliders.css )
Rails.application.config.assets.precompile += %w( responsive.css )
Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( trumbowyg.min.css )

# JS files
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
