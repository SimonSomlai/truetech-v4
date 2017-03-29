Rails.application.config.assets.precompile += %w( .svg .eot .woff .woff2 .ttf )
Rails.application.config.assets.compress = true

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
Rails.application.config.assets.precompile << Proc.new { |path, fn| fn =~ /vendor\/assets/ }
Rails.application.config.assets.precompile << Proc.new { |path, fn| fn =~ /app\/assets/  }
