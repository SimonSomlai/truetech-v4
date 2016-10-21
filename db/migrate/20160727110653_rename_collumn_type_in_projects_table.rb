class RenameCollumnTypeInProjectsTable < ActiveRecord::Migration
  def change
  	rename_column :projects, :type, :service
  end
end
