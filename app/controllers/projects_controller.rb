class ProjectsController < ApplicationController
  include ProjectsHelper
  before_action :setup, only: [:show, :edit, :update, :destroy]
  before_filter :logged_in_user?, except: [:show]
  before_filter :is_admin?, except: [:show]

  def index
    @action = "New"
    @projects = Project.all
    @project = Project.new
  end

  def show
    @user = User.find_by(id: @project.user_id).name
    @relatedprojects = Project.includes(:project_images).where(service: @project.service).uniq.limit(6).where.not(id: @project)
    ahoy.track "Project Views", title: "#{@project.title}" unless its_simon? 
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      if params[:project_images] != nil
        @project.update_attribute(:user_id, current_user.id)
        params[:project_images]["images"].each do |a|
          @project_image = @project.project_images.create!(:images => a)
        end
      end
      flash[:success] = "Project succesfully created!"
      redirect_to projects_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def edit
    @projects = Project.all
    @action = "Edit"
    render :index
  end

  def update
    if @project.update(project_params)
      if params[:project_images] != nil
        @project.project_images.destroy_all
        params[:project_images]["images"].each do |a|
          @project_image = @project.project_images.create!(:images => a)
        end
      end
      flash[:success] = "Project succesfully updated!"
      redirect_to projects_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path
      flash[:success] = "Project succesfully deleted!"
    else
      flash[:danger] = "Something went wrong"
      redirect_to projects_path
    end
  end
end
