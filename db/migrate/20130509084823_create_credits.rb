class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :company 

      # 联络信息
      t.string :reg_address #注册地址
      t.string :reg_zip     #注册地址邮编
      t.string :opt_address #经营地址
      t.string :opt_zip     #经营地址邮编
      t.string :zone        #所在园区
      t.string :industry    #所属行业
      t.string :tel         #联系电话
      t.string :fax         #联系传真
      t.string :email       #电子邮箱
      t.string :website     #网址

      # 经营信息
      t.string :main_product  #主要产品或服务
      t.string :sales_region  #销售区域
      t.string :clients_type  #客户类型
      t.string :upstream      #列举主要上游供应商、合作方及付款方式
      t.string :downstream    #列举主要下游客户及收款方式
      t.string :opt_stage     #运营阶段

      # 人员情况
      t.integer :epl_count  #员工总数
      t.integer :master     #硕士以上人数
      t.integer :bachelor   #大学本科人数
      t.integer :junior     #大专人数
      t.integer :other      #其他学历人数

      # 经营场所
      t.float :self_area   #自有房产总面积
      t.float :self_head   #自有总部面积
      t.float :self_branch #自有分部面积
      t.float :self_value  #自有房产原值或年租金
      t.float :rent_area   #租赁房产总面积
      t.float :rent_head   #租赁总部面积
      t.float :rent_branch #租赁分部面积
      t.float :rent_value  #租赁房产原值或年租金  
      t.float :mort_area   #按揭房产总面积
      t.float :mort_head   #按揭总部面积
      t.float :mort_branch #按揭分部面积
      t.float :mort_value  #按揭房产原值或年租金

      # 开户信息
      t.string :bank_name    #开户银行
      t.string :bank_account #账号
      t.string :bank_address #开户行地址
      t.string :bank_tel     #开户电话
      t.integer :avg_digits  #月均存款位数
      t.string :bank_level   #信用等级

      # 其他信息1
      t.boolean :bad_cert   #不良工商记录
      t.boolean :bad_tax    #不良税务记录
      t.boolean :bad_social #不良社保记录
      t.boolean :bad_trade  #不良交易记录
      t.boolean :involved_before #是否曾参与申请征信或评级
      t.boolean :bad_manage #行业管理的不良记录
      t.boolean :bad_court  #不良司法记录

      t.text :industry_review #行业评价

      # 财务信息1
      t.float :gross_profit_0  #毛利率
      t.float :ratio_return_0  #总资产报酬率
      t.float :ratio_profit_0  #营业利润率
      t.float :ratio_net_return_0 #净资产收益率
      t.float :ratio_asset_liability_0 #资产负债率
      t.float :ratio_liquidity_0 #流动比率
      t.float :ratio_quick_0     #速动比率
      t.float :ratio_ar_0        #应收账款周转速度
      t.float :ratio_inventory_0 #存贷周转速度
      t.float :ratio_assets_0    #总资产周转速度

      t.float :gross_profit_1  #毛利率
      t.float :ratio_return_1  #总资产报酬率
      t.float :ratio_profit_1  #营业利润率
      t.float :ratio_net_return_1 #净资产收益率
      t.float :ratio_asset_liability_1 #资产负债率
      t.float :ratio_liquidity_1 #流动比率
      t.float :ratio_quick_1     #速动比率
      t.float :ratio_ar_1        #应收账款周转速度
      t.float :ratio_inventory_1 #存贷周转速度
      t.float :ratio_assets_1    #总资产周转速度

      t.float :gross_profit_2  #毛利率
      t.float :ratio_return_2  #总资产报酬率
      t.float :ratio_profit_2  #营业利润率
      t.float :ratio_net_return_2 #净资产收益率
      t.float :ratio_asset_liability_2 #资产负债率
      t.float :ratio_liquidity_2 #流动比率
      t.float :ratio_quick_2     #速动比率
      t.float :ratio_ar_2        #应收账款周转速度
      t.float :ratio_inventory_2 #存贷周转速度
      t.float :ratio_assets_2    #总资产周转速度

      t.string :credit_lvl       #信用等级

      t.timestamps
    end
  end
end
