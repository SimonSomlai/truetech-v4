# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.truetech.be/nl"

SitemapGenerator::Sitemap.create do
    Article.find_each do |article|
     add articles_show_path(article, article: article.slug_en, locale: :en)
     add articles_show_path(article, article: article.slug_nl, locale: :nl)
    end
    Project.find_each do |project|
     add project_path(project, locale: :en)
     add project_path(project, locale: :nl)
    end
    Page.find_each do |page|
     add page_path(page, locale: :en)
     add page_path(page, locale: :nl)
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
