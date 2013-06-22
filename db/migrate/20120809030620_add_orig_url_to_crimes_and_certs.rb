class AddOrigUrlToCrimesAndCerts < ActiveRecord::Migration
  def change
    add_column :certs,  :orig_url, :text  # 数据的原始地址, string(255)存储不下
    add_column :crimes, :orig_url, :text
  end
end
