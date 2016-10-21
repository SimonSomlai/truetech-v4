class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.text :body
      t.string :image
      t.references :user, index: true, foreign_key: true
      t.string :category
      t.boolean :posted, default: false
      t.timestamps null: false
    end
    add_index :articles, :category
    add_index :articles, :posted
  end
end
