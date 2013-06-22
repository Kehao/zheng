class CreateStatisticClients < ActiveRecord::Migration
  def change
    create_table :statistic_clients do |t|

      t.string :micro
      t.belongs_to :user,null:false
      t.string :region_code,default:nil

      t.integer :company,default: 0
      t.integer :company_court,default: 0
      t.integer :company_court_ok,default: 0
      t.integer :company_court_closed,default: 0
      t.integer :company_court_stopped,default: 0
      t.integer :company_court_other,default: 0
      t.integer :company_court_processing,default: 0
      t.integer :seek,default: 0
      t.datetime :from_at
      t.datetime :to_at
      t.timestamps
    end
  end
end
