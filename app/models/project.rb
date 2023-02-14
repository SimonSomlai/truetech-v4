class Project < ActiveRecord::Base
  before_save { self.service = service.downcase }

  # Relationships
  belongs_to :user
  has_many :project_tags
  has_many :tags, :through => :project_tags
  has_many_attached :project_images

  validates :title, :link, presence: true

  # Be able to search projects by their title attribute
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: [:finished, :in_progress]
end
