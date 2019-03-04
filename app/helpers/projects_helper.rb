module ProjectsHelper
  def headerimage(project) # Set headerimage for object
    if project.project_images.any?
      project.project_images.first.images_url(:small)
    end
  end

  def is_video(item)
    url = item.images_url
    !!url.match(/.mp4/)
  end

  def features # Convert serialized string to usable hash, (I know I should've used regular hash lol)
    @project.features.gsub(/[{}]/,'').split(',').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
  end

  def project_params
    params.require(:project).permit(:title, :description, :en_description, :features, :link, :service, :follow_up, :skills, :slug, project_images_attributes: [:id, :post_id, :images])
  end

  def setup
    @projects = Project.all.includes(:project_images).order("created_at desc")
    @project = Project.friendly.find(params[:id])
  end
end
