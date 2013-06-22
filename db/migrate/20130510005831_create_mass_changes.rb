class CreateMassChanges < ActiveRecord::Migration
  def change
    create_table :mass_changes do |t|
      t.references :credit

      t.date   :change_at      #   变更日期
      t.string :event          #   变更事项
      t.string :before         #   变更前
      t.string :after          #   变更后

      t.timestamps
    end
  end
end
