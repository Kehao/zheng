class AddSnapshotPathToCrime < ActiveRecord::Migration
  def change
    add_column :crimes, :snapshot_path, :string
  end
end
