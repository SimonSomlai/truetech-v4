class Article < ActiveRecord::Base
  # Relationship to user
  belongs_to :user

  # Validations
  validates :category, presence: true

  # Image uploading
  mount_uploader :image, ArticleImageUploader
  process_in_background :image
  # store_in_background :image

  # Friendly ID slugs, 2 languages (slug_en & slug_nl)
  extend FriendlyId
  friendly_id :title, :use => [:slugged, :simple_i18n]
end
