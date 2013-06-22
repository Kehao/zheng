class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :number

      t.boolean :idinfo_crawled,    default: false     # 判断是否已获取
      t.boolean :court_crawled,     default: false
      t.boolean :water_crawled,     default: false
      t.boolean :power_crawled,     default: false
      t.boolean :sentiment_crawled, default: false

      t.references :owner

      t.timestamps
    end
  end
end
