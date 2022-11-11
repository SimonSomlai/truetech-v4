class Project < ActiveRecord::Base
  before_save { self.service = service.downcase }

  # Relationship w user
  belongs_to :user

  # Validations (thanks Rich ;))
  validates :title, :link,  :skills, :features, :service, presence: true
  
  # Relationship w images
  has_many :project_images, dependent: :destroy
  accepts_nested_attributes_for :project_images

  has_many_attached :project_images_new

  # Serialization of tags
  serialize :features

  # Be able to search projects by their title attribute
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: [:finished, :in_progress]
end
