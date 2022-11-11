class RemoveColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :image
    remove_column :articles, :image_tmp
  end
end
