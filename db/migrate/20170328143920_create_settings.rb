class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :settings, :key
  end
end
