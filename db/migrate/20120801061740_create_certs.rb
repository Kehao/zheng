class CreateCerts < ActiveRecord::Migration
  def change
    create_table :certs do |t|
      t.string  :regist_id              # 注册号
      t.string  :name                   # 名称
      t.string  :address                # 地址
      t.string  :owner_name             # 法人
      t.string  :regist_capital         # 注册资本
      t.string  :paid_in_capital        # 实收资本
      t.string  :company_type           # 公司类型(有限公司/无限公司)
      t.string  :found_date             # 成立时间
      t.string  :business_scope         # 经营范围
      t.string  :business_start_date    # 经营起始时间
      t.string  :business_end_date      # 经营结束时间
      t.string  :regist_org             # 登机机关
      t.string  :approved_date          # 核准日期 
      t.string  :check_years            # 年检年份

      t.references :company

      t.timestamps
    end
  end
end
