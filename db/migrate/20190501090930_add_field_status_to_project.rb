class AddFieldStatusToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :status, :integer
  end
end
