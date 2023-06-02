# frozen_string_literal: true
class ProjectsController < ApplicationController
  include ProjectsHelper
  before_action :setup, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user?, except: [:show, :all_projects]
  before_action :is_admin?, except: [:show, :all_projects]

  def index
    @action = 'New'
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
    @project = Project.new
  end

  def all_projects
    @tags = Tag.all
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
  end

  def list
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
    render json: @projects
  end

  def show
    @user = User.find_by(id: @project.user_id).name
    @relatedprojects = Project.includes(:project_images_attachments).where(service: @project.service).where.not(id: @project).sort_by(&:created_at).uniq.take(6).reverse
  end

  def create
    @project = Project.new(project_params)
    @project[:user_id] = current_user.id
    @project.project_images.attach(project_params[:project_images]) if project_params[:project_images]
    if @project.save
      update_tags(params[:new_tags])
      flash[:success] = 'Project succesfully created!'
      redirect_to projects_path
    else
      flash[:danger] = 'Something went wrong!'
      render :index
    end
    system "rake jobs:workoff"
  end

  def edit
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
    @action = 'Edit'
    render :index
  end

  def update_tags(tags)
    return if tags.empty?

    tag_names = tags.split(",")
    @project.tags.destroy_all
    tag_names.each do |name|
      match = Tag.find_by(name: name)
      if(match)
        ProjectTag.create(project_id: @project.id, tag_id: match.id)
      else 
        new_tag = Tag.create(name: name)
        ProjectTag.create(project_id: @project.id, tag_id: new_tag.id)
      end
    end
  end

  def update
    @action = 'Edit'
    ActiveStorage::Attachment.where(record_type: "Project", record_id: @project.id).destroy_all if project_params[:project_images] # Remove current attachments if new are selected
    if @project.update(project_params)
      update_tags(params[:new_tags])
      flash[:success] = 'Project succesfully updated!'
    else
      flash[:danger] = 'Something went wrong!'
    end
    redirect_back(fallback_location: projects_path)
    system "rake jobs:workoff"
  end

  def destroy
    if @project.destroy
      flash[:success] = 'Project succesfully deleted!'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to projects_path
  end
end
