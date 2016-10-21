class AddCollumnsToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :en_title, :string
  	add_column :articles, :en_description, :text
  	add_column :articles, :en_body, :text
  end
end
