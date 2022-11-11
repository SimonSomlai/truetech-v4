class DropTableProjectImages < ActiveRecord::Migration[6.0]
  def change
    drop_table :project_images
  end
end
