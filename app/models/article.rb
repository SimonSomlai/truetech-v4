class Article < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :category, presence: true
  validates :body, presence: true
  validates :description, presence: true

  # Image uploading
  mount_uploader :image, ArticleImageUploader

  # Friendly URL
  extend FriendlyId
  friendly_id :title, :use => [:slugged, :simple_i18n]
end
