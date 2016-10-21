class Removeslugs < ActiveRecord::Migration
  def change
  	remove_column :articles, :slug_nl
  	remove_column :articles, :slug_en
  end
end
