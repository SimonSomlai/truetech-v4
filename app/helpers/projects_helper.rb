module ProjectsHelper
  def project_params
    params.require(:project).permit(:title, :description, :en_description, :features, :link, :service, :skills, :slug, project_images_attributes: [:id, :post_id, :images])
  end

  # Set headerimage for object
  def headerimage(item)
    if item.project_images.any?
      item.project_images.first.images_url(:small)
    end
  end

  # Convert serialized string to usable hash
  def features
    @project.features.gsub(/[{}]/,'').split(',').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
  end

  # Cleaning up the controller
  def setup
    @project = Project.friendly.find(params[:id])
  end
end
