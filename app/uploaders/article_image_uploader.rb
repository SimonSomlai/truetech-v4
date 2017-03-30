# encoding: utf-8

class ArticleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :optimize
  # Choose what kind of storage to use for this uploader:
  storage (Rails.env.production? ? :fog : :file)

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :small do
    process resize_to_fit: [350,200]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def optimize
    manipulate! do |img|
      img.combine_options do |c|
        c.quality '90'
      end
      img
    end
  end
end
