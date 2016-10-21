module TestimonialsHelper
  def testimonial_params
    params.require(:testimonial).permit(:en_quote, :name, :company, :link, :image, :quote)
  end

  def setup
    @testimonial = Testimonial.find(params[:id])
  end
end
