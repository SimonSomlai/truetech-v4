class ProjectImage < ActiveRecord::Base
  belongs_to :project # Belongs to a project
  mount_uploader :images, ProjectImagesUploader
end
