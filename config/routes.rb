# frozen_string_literal: true

Rails.application.routes.draw do
  get 'routes/redirect'
  get '/sitemap.xml.gz', to: redirect('https://s3-eu-west-1.amazonaws.com/truetech-v4/sitemap.xml.gz'), as: :sitemap

  # Contactform routing using mail_form gem
  resources :contactforms, only: [:create]

  scope '(:locale)', locale: /en|nl/ do
    # Root to home_path
    root 'static_pages#home', as: 'home'

    # Session routing
    get 'login' => 'sessions#new', route: 'login', as: :new_user_session
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy', route: 'logout', as: :destroy_user_session
    # Static routes (automatically generates controller#path_path)
    get 'single-page' => 'static_pages#single_page'
    get 'starters-website' => 'static_pages#starters_website'
    get 'website-op-maat' => 'static_pages#website_op_maat'
    get 'webapplicatie' => 'static_pages#webapplicatie'
    # get "website-analyse" => "static_pages#website_analyse"

    get 'all-projects' => 'projects#all_projects'
    get 'all-articles' => 'articles#all_articles'

    get 'admin' => 'static_pages#admin'
    get 'callback' => 'static_pages#callback'
    resources :users, :projects, :testimonials, :articles, :pages

    #  This routes pages and articles. First it searches for a matching article by slug (friendly id), then
    #  falls down to pages. Ex;
    #  www.mysite.com/this-is-the-title-of-the-article  (articles#show)
    #  www.mysite.com/about-me (pages#show)
    class ArticleUrlConstrainer
      def matches?(request)
        id = request.path.gsub('/', '')[2..-1]
        @article = Article.where(slug_nl: id).first || Article.where(slug_en: id).first
        @article = if I18n.locale == :en
                     Article.find_by(slug_en: id) || Article.find_by(slug_nl: id)
                   else
                     Article.find_by(slug_nl: id) || Article.find_by(slug_en: id)
                   end
      end
    end

    constraints(ArticleUrlConstrainer.new) do
      match '/:id', via: [:get], to: 'articles#show'
    end

    class PageUrlConstrainer
      def matches?(request)
        id = request.path.gsub('/', '')[2..-1]
        @page = Page.friendly.find(id)
      end
    end

    constraints(PageUrlConstrainer.new) do
      match '/:id', via: [:get], to: 'pages#show'
    end

    resources :articles, only: [:show], path: '', as: 'articles_show'
    resources :pages, only: [:show], path: '', as: 'pages_show'

    # Don't search deeper if assets weren't found
    match '*path', via: [:get], to: 'locale#not_found'
  end

  match '*path', via: [:get], to: redirect("/#{I18n.default_locale}/%{path}")
  match '', via: [:get], to: redirect("/#{I18n.default_locale}")
end
