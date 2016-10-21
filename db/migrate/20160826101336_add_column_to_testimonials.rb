class AddColumnToTestimonials < ActiveRecord::Migration
  def change
  	add_column :testimonials, :en_quote, :text
  end
end
