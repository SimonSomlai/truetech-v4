# frozen_string_literal: true
class ProjectsController < ApplicationController
  include ProjectsHelper
  before_action :setup, only: [:show, :edit, :update, :destroy]
  before_filter :logged_in_user?, except: [:show, :all_projects]
  before_filter :is_admin?, except: [:show, :all_projects]

  def index
    @action = 'New'
    @projects = Project.all.includes(:project_images).order("created_at desc")
    @project = Project.new
  end

  def all_projects
    @projects ||= Rails.cache.fetch('all_projects', expires_in: 1.days) do
      Project.all.includes(:project_images).order("created_at desc")
    end
  end

  def show
    @user = User.find_by(id: @project.user_id).name
    @relatedprojects = Project.includes(:project_images).where(service: @project.service).where.not(id: @project).uniq.limit(6)
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      unless params[:project_images].nil?
        @project.update_attribute(:user_id, current_user.id)
        params[:project_images]['images'].each do |image|
          @project_image = @project.project_images.create!(images: image)
        end
      end
      flash[:success] = 'Project succesfully created!'
      redirect_to projects_path
    else
      flash[:danger] = 'Something went wrong!'
      render :index
    end
  end

  def edit
    @projects = Project.all.includes(:project_images).order("created_at desc")
    @action = 'Edit'
    render :index
  end

  def update
    @action = 'Edit'
    if @project.update(project_params)
      unless params[:project_images].nil?
        @project.project_images.destroy_all
        params[:project_images]['images'].each do |image|
          @project_image = @project.project_images.create!(images: image)
        end
      end
      flash[:success] = 'Project succesfully updated!'
    else
      flash[:danger] = 'Something went wrong!'
    end
    render :index
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
