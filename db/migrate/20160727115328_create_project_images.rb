class CreateProjectImages < ActiveRecord::Migration
  def change
    create_table :project_images do |t|
      t.references :project, index: true, foreign_key: true
      t.text :images

      t.timestamps null: false
    end
  end
end
