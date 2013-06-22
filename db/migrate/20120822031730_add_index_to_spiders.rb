class AddIndexToSpiders < ActiveRecord::Migration
  def change
    add_index :spiders, [:sponsor_id, :sponsor_type]
    add_index :spiders, :status
  end
end
