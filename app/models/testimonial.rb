class Testimonial < ActiveRecord::Base
  mount_uploader :image, TestimonialPictureUploader
  process_in_background :image
  # store_in_background :image
end
