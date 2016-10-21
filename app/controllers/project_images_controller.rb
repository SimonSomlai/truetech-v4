class ProjectImagesController < ApplicationController
  before_action :set_project_image, only: [:show, :edit, :update, :destroy]

  # GET /project_images
  # GET /project_images.json
  def index
    @project_images = ProjectImage.all
  end

  # GET /project_images/1
  # GET /project_images/1.json
  def show
  end

  # GET /project_images/new
  def new
    @project_image = ProjectImage.new
  end

  # GET /project_images/1/edit
  def edit
  end

  # POST /project_images
  # POST /project_images.json
  def create
    @project_image = ProjectImage.new(project_image_params)

    respond_to do |format|
      if @project_image.save
        format.html { redirect_to @project_image, notice: 'Project image was successfully created.' }
        format.json { render :show, status: :created, location: @project_image }
      else
        format.html { render :new }
        format.json { render json: @project_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_images/1
  # PATCH/PUT /project_images/1.json
  def update
    respond_to do |format|
      if @project_image.update(project_image_params)
        format.html { redirect_to @project_image, notice: 'Project image was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_image }
      else
        format.html { render :edit }
        format.json { render json: @project_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_images/1
  # DELETE /project_images/1.json
  def destroy
    @project_image.destroy
    respond_to do |format|
      format.html { redirect_to project_images_url, notice: 'Project image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_image
      @project_image = ProjectImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_image_params
      params.require(:project_image).permit(:projects_id, :images)
    end
end
