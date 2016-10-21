Rails.application.routes.draw do
  get 'routes/redirect'

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
  # Root to home_path
  root "static_pages#home", as: "home"

  # Session routing
  get "login" => "sessions#new", as: "login"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: "logout"

  # Static routes
  get "single-page" => "static_pages#single_page"
  get "starters-website" => "static_pages#starters_website"
  get "website-op-maat" => "static_pages#website_op_maat"
  get "webapplicatie" => "static_pages#webapplicatie"
  get "website-analyse" => "static_pages#website_analyse"
  get "admin" => "static_pages#admin"

  # Standard routing
  resources :users, :projects, :testimonials, :articles, :pages
  class ArticleUrlConstrainer
    def matches?(request)
      id = request.path.gsub("/", "")[2..-1]
      @article = Article.where(slug_nl: id).first || Article.where(slug_en: id).first
      if I18n.locale == :en
        @article = Article.find_by(slug_en: id) || Article.find_by(slug_nl: id)
      else
        @article = Article.find_by(slug_nl: id) || Article.find_by(slug_en: id)
      end
    end
  end

  constraints(ArticleUrlConstrainer.new) do
    match '/:id', :via => [:get], to: "articles#show"
  end

  class PageUrlConstrainer
    def matches?(request)
      id = request.path.gsub("/", "")[2..-1]
      @page = Page.friendly.find(id)
    end
  end

  constraints(PageUrlConstrainer.new) do
    match '/:id', :via => [:get], to: "pages#show"
  end

  resources :articles, :only => [:show], :path => '', as: "articles_show"
  resources :pages, :only => [:show], :path => '', as: "pages_show"

  # Contactform routing using mail_form gem
  resources :contactforms, only: [:create]
  # Don't search deeper if assets weren't found
  match "*path",  :via => [:get], to: "locale#not_found"
end

match '*path',  :via => [:get], to: redirect("/#{I18n.default_locale}/%{path}")
match '', :via => [:get], to: redirect("/#{I18n.default_locale}")
end
