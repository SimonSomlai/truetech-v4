class Testimonial < ActiveRecord::Base
  mount_uploader :image, TestimonialPictureUploader
end
