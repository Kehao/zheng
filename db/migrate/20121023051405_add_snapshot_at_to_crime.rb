class AddSnapshotAtToCrime < ActiveRecord::Migration
  def change
    add_column :crimes, :snapshot_at, :datetime
  end
end
