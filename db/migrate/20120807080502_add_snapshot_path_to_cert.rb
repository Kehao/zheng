class AddSnapshotPathToCert < ActiveRecord::Migration
  def change
    add_column :certs, :snapshot_path, :string
  end
end
