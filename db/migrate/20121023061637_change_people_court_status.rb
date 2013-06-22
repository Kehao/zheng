class ChangePeopleCourtStatus < ActiveRecord::Migration
  def up
    change_column :people, :court_status, :integer, :default => 0
    add_index     :people, :court_status
  end

  def down
    change_column :companies, :court_status, :string, :default => "success"
  end
end
