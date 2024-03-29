class TestimonialsController < ApplicationController
  include TestimonialsHelper
  before_action :setup, only: [:edit, :update, :destroy]
  before_action :logged_in_user?
  before_action :is_admin?

  def index
    @action = "New"
    @testimonials = Testimonial.all
    @testimonial = Testimonial.new
  end

  def list
    @testimonials = Testimonial.all
    render json: @testimonials
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      flash[:success] = "testimonial succesfully created!"
      redirect_to testimonials_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
    system "rake jobs:workoff"
  end

  def edit
    @testimonials = Testimonial.all
    @action = "Edit"
    render :index
  end

  def update
    if @testimonial.update(testimonial_params)
      flash[:success] = "testimonial succesfully updated!"
      redirect_to testimonials_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
    system "rake jobs:workoff"
  end

  def destroy
    if @testimonial.destroy
      flash[:success] = "testimonial succesfully deleted!"
      redirect_to testimonials_path
    else
      flash[:danger] = "Something went wrong!"
      render :index
    end
  end
end
