class CreateEquips < ActiveRecord::Migration
  def change
    create_table :equips do |t|
      t.references :credit
      
      t.string :name  # 设备名称
      t.string :count # 数量
      t.string :tech  # 技术水平
      t.string :memo  # 备注

      t.timestamps
    end
  end
end

