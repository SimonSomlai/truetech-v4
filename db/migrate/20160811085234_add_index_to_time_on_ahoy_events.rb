class AddIndexToTimeOnAhoyEvents < ActiveRecord::Migration
  def change
  	add_index :ahoy_events, :time
  	add_index :visits, :started_at
  end
end
