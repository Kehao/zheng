class AddSnapshotAtToCert < ActiveRecord::Migration
  def change
    add_column :certs, :snapshot_at, :datetime
  end
end
