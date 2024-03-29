# encoding: utf-8

class TestimonialPictureUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
 process :optimize
 process resize_to_limit: [150, 150]
  # Choose what kind of storage to use for this uploader:
  storage (Rails.env.production? ? :fog : :file)

  def extension_white_list
    %w(jpg jpeg gif png mov)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def optimize
    manipulate! do |img|
      img.combine_options do |c|
        c.strip
        c.quality '50'
        c.depth '5'
        c.interlace 'Line'
      end
      img
    end
  end

  def default_url
    ""
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
