class CreateHolderChanges < ActiveRecord::Migration
  def change
    create_table :holder_changes do |t|
      t.references :credit
      t.date   :change_at     #   变更日期
      t.string :name          #   股东名称
      t.float :before_amount  #   变更前出资额
      t.float :before_percent #   变更前比例
      t.float :after_amount   #   变更后出资额
      t.float :after_percent  #   变更后比例 

      t.timestamps
    end
  end
end

