class DropTableVisits < ActiveRecord::Migration[5.0]
  def change
    drop_table :visits
  end
end
