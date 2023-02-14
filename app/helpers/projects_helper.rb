module ProjectsHelper
  def headerimage(project) # Set headerimage for object
    if project.project_images.attached?
      return project.project_images.first.variant(resize_to_fit: [400,300])
    end
    return ""
  end

  def project_params
    params.require(:project).permit(:new_tags, :title, :description, :en_description, :features, :link, :service, :follow_up, :skills, :slug, project_images: [], project_images_attributes: [:id, :project_id, :images])
  end

  def setup
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
    @project = Project.friendly.find(params[:id])
  end
end
