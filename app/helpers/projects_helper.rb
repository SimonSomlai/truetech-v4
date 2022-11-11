module ProjectsHelper
  def headerimage(project) # Set headerimage for object
    if project.project_images.any?
      return project.project_images.first.images_url(:small)
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
    @projects = Project.all.includes(:project_images).sort_by(&:created_at).reverse
    @project = Project.friendly.find(params[:id])
  end
end
