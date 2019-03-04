class ProjectImage < ActiveRecord::Base
  belongs_to :project # Belongs to a project
  mount_uploader :images, ProjectImagesUploader
  process_in_background :images
  # store_in_background :images
end
