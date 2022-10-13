class Article < ActiveRecord::Base
  has_rich_text :en_content
  has_rich_text :content
  # Relationship to user
  belongs_to :user

  # Validations
  validates :category, presence: true

  # Image uploading
  mount_uploader :image, ArticleImageUploader

  # Friendly ID slugs, 2 languages (slug_en & slug_nl)
  extend FriendlyId
  friendly_id :title, :use => [:slugged, :simple_i18n]
end
