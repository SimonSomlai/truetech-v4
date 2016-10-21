class AddNamedSlugsForEachLocaleToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :slug_en, :string, index: true
  	add_column :articles, :slug_nl, :string, index: true
  end
end
