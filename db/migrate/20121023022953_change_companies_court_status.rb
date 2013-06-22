#encoding: utf-8
class ChangeCompaniesCourtStatus < ActiveRecord::Migration
  def up
    change_column :companies, :court_status, :integer, :default => 0
    add_index     :companies, :court_status
  end

  def down
    change_column :companies, :court_status, :string, :default => "success"
  end
end
