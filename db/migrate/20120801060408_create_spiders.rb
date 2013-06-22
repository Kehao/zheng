class CreateSpiders < ActiveRecord::Migration
  def change
    create_table :spiders do |t|
      t.references :sponsor, polymorphic: true  # 被抓去取对象
      t.integer    :status,  default: 0         # waiting/running/complete
      t.text       :data                        # 抓取缓存的数据

      t.timestamps
    end
  end
end
