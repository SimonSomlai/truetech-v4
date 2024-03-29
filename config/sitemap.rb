# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.simonsomlai.com"
SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
aws_access_key_id: ENV["S3_ACCESS_KEY"],
aws_secret_access_key: ENV["S3_SECRET_KEY"],
fog_provider: 'AWS',
fog_directory: ENV["S3_BUCKET_NAME"],
fog_region: ENV["S3_REGION"]
)

SitemapGenerator::Sitemap.sitemaps_host = "https://truetech-v4.s3.amazonaws.com"

SitemapGenerator::Sitemap.create do
    Article.find_each do |article|
     add articles_show_path(article.slug_en, locale: :en)
     add articles_show_path(article.slug_nl, locale: :nl) if article.slug_nl != ""
    end
    Project.find_each do |project|
     add project_path(project, locale: :en)
     add project_path(project, locale: :nl)
    end
    Page.find_each do |page|
     add pages_show_path(page, locale: :en)
     add pages_show_path(page, locale: :nl)
    end

    add "en/single-page"
    add "nl/single-page"
    add "nl/starters-website"
    add "en/starters-website"
    add "nl/website-op-maat"
    add "en/website-op-maat"
    add "nl/webapplicatie"
    add "en/webapplicatie"
    add "nl/website-analyse"
    add "en/website-analyse"
end
