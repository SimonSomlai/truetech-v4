class AddEnDescriptionToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :en_description, :text
  end
end
