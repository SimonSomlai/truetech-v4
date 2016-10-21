class RenameSlugToEnAndAddNlSlug < ActiveRecord::Migration
  def change
  	rename_column :articles, :slug, :slug_nl
  	add_column :articles, :slug_en, :string, index: true
  end
end
