class CreateMorts < ActiveRecord::Migration
  def change
    create_table :morts do |t|
      t.references :credit
      
      t.string  :name     #   担保名称
      t.string  :category #   担保种类
      t.float   :amount   #   担保额度
      t.integer :due_time #   担保期限
      t.date    :deadline #   到期日
      t.float   :balance  #   目前余额

      t.timestamps
    end
  end
end

