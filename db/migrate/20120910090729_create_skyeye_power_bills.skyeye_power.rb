# This migration comes from skyeye_power (originally 20120904075025)
class CreateSkyeyePowerBills < ActiveRecord::Migration
  def change
    create_table :skyeye_power_bills do |t|
      t.decimal :amount,:precision=>8,:scale=>2,:default=>0 #用水(电)量
      t.decimal :cost,:precision=>8,:scale=>2,:default=>0   #账单金额(元)
      t.datetime :record_time    #记录时间　
      t.boolean :paid            #是否缴费
      t.string :number           #水电号
      t.string :last_number      #上次抄表见数
      t.string :this_number      #本次抄表见数
      t.integer :category,default:1 #账单类型 1:水费 2:电费 3:etc..
      t.belongs_to :company

      t.timestamps
    end
  end
end
