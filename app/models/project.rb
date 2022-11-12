class Project < ActiveRecord::Base
  before_save { self.service = service.downcase }

  # Relationship w user
  belongs_to :user

  # Validations (thanks Rich ;))
  validates :title, :link,  :skills, :features, :service, presence: true

  has_many_attached :project_images

  # Serialization of tags
  serialize :features

  # Be able to search projects by their title attribute
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: [:finished, :in_progress]
end
