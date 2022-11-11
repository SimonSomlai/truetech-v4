module ProjectsHelper
  def headerimage(project) # Set headerimage for object
    if project.project_images_new.attached?
      return project.project_images_new.first.variant(resize_to_fit: [400,300])
    end
    return ""
  end

  def features # Convert serialized string to usable hash, (I know I should've used regular hash lol)
    @project.features.gsub(/[{}]/,'').split(',').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
  end

  def project_params
    params.require(:project).permit(:title, :description, :en_description, :features, :link, :service, :follow_up, :skills, :slug, :project_images_new, project_images_attributes: [:id, :project_id, :images])
  end

  def setup
    @projects = Project.all.includes(:project_images_new_attachments).sort_by(&:created_at).reverse
    @project = Project.friendly.find(params[:id])
  end
end
