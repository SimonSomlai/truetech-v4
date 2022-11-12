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
    @projects = Project.all.includes(:project_images_attachments).sort_by(&:created_at).reverse
  end

  def show
    @user = User.find_by(id: @project.user_id).name
    @relatedprojects = Project.includes(:project_images_attachments).where(service: @project.service).where.not(id: @project).sort_by(&:created_at).uniq.take(6).reverse
  end

  def create
    @project = Project.new(project_params)
    @project[:user_id] = current_user.id
    @article.project_images.attach(project_params[:project_images]) if project_params[:project_images]
    if @project.save
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

  def update
    @action = 'Edit'
    if @project.update(project_params)
      flash[:success] = 'Project succesfully updated!'
    else
      flash[:danger] = 'Something went wrong!'
    end
    render :index
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
