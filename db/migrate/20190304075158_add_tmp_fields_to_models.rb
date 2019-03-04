class AddTmpFieldsToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_picture_tmp, :string
    add_column :testimonials, :image_tmp, :string
    add_column :articles, :image_tmp, :string
    add_column :project_images, :images_tmp, :text
  end
end
