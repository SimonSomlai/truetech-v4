class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.date :date
      t.integer :visitors
      t.integer :pageviews
      t.text :referrers
      t.text :keywords
      t.text :top_content
      t.timestamps
    end
    add_index :visits, :date
  end
end
