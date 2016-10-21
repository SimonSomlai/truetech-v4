class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :name
      t.string :company
      t.text :quote
      t.string :image
      t.string :link

      t.timestamps null: false
    end
  end
end
