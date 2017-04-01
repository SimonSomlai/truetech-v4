class AddFollowUpToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :follow_up, :boolean
    add_index :projects, :follow_up
  end
end
