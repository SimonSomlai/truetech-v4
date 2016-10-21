class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.text :features
      t.string :link
      t.string :type
      t.string :skills
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :projects, :type
  end
end
