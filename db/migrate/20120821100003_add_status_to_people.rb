class AddStatusToPeople < ActiveRecord::Migration
  def change
    add_column :people, :idinfo_status, :string
    add_column :people, :court_status,  :string
    add_column :people, :sentiment_status, :string
  end
end
