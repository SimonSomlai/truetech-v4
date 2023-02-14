class Tag < ApplicationRecord
  has_many :project_tags
  has_many :projects, :through => :project_tags
  validates :name, uniqueness: true, presence: true
end
