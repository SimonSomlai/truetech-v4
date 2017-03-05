class Article < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Validations
  validates :category, presence: true

  # Don't validate nl locale when it's a technical_article
  with_options unless: :technical_article? do
    validates :title, presence: true
    validates :body, presence: true
    validates :description, presence: true
  end

  # Validate en locale when it's technical_article
  with_options if: :technical_article? do
    validates :en_title, presence: true
    validates :en_body, presence: true
    validates :en_description, presence: true
  end

  def technical_article?
    self.category.downcase == "coding"
  end

  # Image uploading
  mount_uploader :image, ArticleImageUploader

  # Friendly URL
  extend FriendlyId
  friendly_id :title, :use => [:slugged, :simple_i18n]
end
