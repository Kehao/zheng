class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :credit
      
      t.string  :name     #   贷款行名称
      t.string  :category #   贷款种类
      t.float   :amount   #   贷款额度
      t.integer :due_time #   贷款期限
      t.date    :deadline #   到期日
      t.float   :balance  #   目前余额

      t.timestamps
    end
  end
end

