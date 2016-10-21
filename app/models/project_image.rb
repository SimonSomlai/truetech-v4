class ProjectImage < ActiveRecord::Base
  belongs_to :project
  mount_uploader :images, ProjectImagesUploader
end
